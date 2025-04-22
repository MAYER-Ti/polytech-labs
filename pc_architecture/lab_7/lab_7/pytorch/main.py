import torch
import torch.optim as optim
from torchvision import transforms, models
from PIL import Image
import matplotlib.pyplot as plt

# ========== ПАРАМЕТРЫ ==========
MAX_SIZE = 256
STEPS = 300
STYLE_WEIGHT = 1e6
USE_ADAM = False
LR = 0.01

# ========== УСТРОЙСТВО ==========
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Используется устройство: {device}")

# ========== МОДЕЛЬ ==========
cnn = models.vgg19(weights=models.VGG19_Weights.IMAGENET1K_V1).features.to(device).eval()

# ========== НОРМАЛИЗАЦИЯ ==========
mean = torch.tensor([0.485, 0.456, 0.406]).to(device)
std = torch.tensor([0.229, 0.224, 0.225]).to(device)

# ========== ЗАГРУЗКА ИЗОБРАЖЕНИЯ ==========
def load_image(path, max_size=MAX_SIZE):
    image = Image.open(path).convert('RGB')
    transform = transforms.Compose([
        transforms.Resize(max_size),
        transforms.ToTensor(),
        transforms.Normalize(mean.tolist(), std.tolist())
    ])
    return transform(image).unsqueeze(0).to(device)

# ========== РАЗНОРМАЛИЗАЦИЯ ==========
def unnormalize(tensor):
    mean_ = mean.view(3, 1, 1).to(tensor.device)
    std_ = std.view(3, 1, 1).to(tensor.device)
    return tensor * std_ + mean_

# ========== ГРАМ-МАТРИЦА ==========
def gram_matrix(tensor):
    b, c, h, w = tensor.size()
    tensor = tensor.view(c, h * w)
    return torch.mm(tensor, tensor.t()) / (c * h * w)

# ========== СЛОИ ==========
content_layer = '21'  # conv4_2
style_layers = ['0', '5', '10', '19', '28']  # conv1_1, conv2_1, ...

# ========== ФУНКЦИЯ ИЗВЛЕЧЕНИЯ ПРИЗНАКОВ ==========
def get_features(image):
    features = {}
    x = image
    for name, layer in cnn.named_children():
        x = layer(x)
        if name in style_layers + [content_layer]:
            features[name] = x
    return features

# ========== ЗАГРУЗКА ИЗОБРАЖЕНИЙ ==========
content_img = load_image("content.jpg")
style_img = load_image("style.jpg")
target_img = content_img.clone().requires_grad_(True)

# ========== ОПТИМИЗАТОР ==========
optimizer = optim.Adam([target_img], lr=LR) if USE_ADAM else optim.LBFGS([target_img])

# ========== ОБУЧЕНИЕ ==========
print("Стилизация началась...")
step = [0]  # обёртка для мутабельности

def closure():
    optimizer.zero_grad()

    target_features = get_features(target_img)
    content_features = get_features(content_img)
    style_features = get_features(style_img)

    # Content loss
    content_loss = torch.mean((target_features[content_layer] - content_features[content_layer]) ** 2)

    # Style loss
    style_loss = 0
    for layer in style_layers:
        gram_t = gram_matrix(target_features[layer])
        gram_s = gram_matrix(style_features[layer])
        style_loss += torch.mean((gram_t - gram_s) ** 2)

    total_loss = content_loss + STYLE_WEIGHT * style_loss
    total_loss.backward()

    if step[0] % 50 == 0:
        print(f"Step {step[0]} / {STEPS} | Loss: {total_loss.item():.2f}")

    step[0] += 1
    return total_loss

if USE_ADAM:
    for _ in range(STEPS):
        closure()
        optimizer.step()
else:
    while step[0] <= STEPS:
        optimizer.step(closure)

# ========== СОХРАНЕНИЕ ==========
print("Стилизация завершена.")
final_img = unnormalize(target_img.squeeze(0).detach()).clamp(0, 1).cpu()
output = transforms.ToPILImage()(final_img)
output.save("output.jpg")
print("Результат сохранен как output.jpg")

# ========== ВИЗУАЛИЗАЦИЯ ==========
plt.imshow(output)
plt.axis("off")
plt.title("Стилизованное изображение")
plt.show()
