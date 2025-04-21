import torch
import torch.optim as optim
from torchvision import transforms, models
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np

# Настройки для ускорения
MAX_SIZE = 128
STEPS = 30
STYLE_WEIGHT = 1e5
USE_ADAM = False
LR = 0.02

device = torch.device("cpu")
torch.set_flush_denormal(True)

# Загрузка модели
cnn = models.vgg19(weights=models.VGG19_Weights.IMAGENET1K_V1).features.to(device).eval()

# Нормализация
mean = torch.tensor([0.485, 0.456, 0.406]).to(device)
std = torch.tensor([0.229, 0.224, 0.225]).to(device)

def load_image(image_path):
    transform = transforms.Compose([
        transforms.Resize(MAX_SIZE),
        transforms.ToTensor(),
        transforms.Normalize(mean.tolist(), std.tolist())
    ])
    return transform(Image.open(image_path).convert('RGB')).unsqueeze(0).to(device)

def gram_matrix(tensor):
    _, c, h, w = tensor.size()
    tensor = tensor.view(c, h * w)
    return torch.mm(tensor, tensor.t()) / (c * h * w)

# Слои
content_layer = '18'
style_layers = ['0', '5', '10', '19', '28']

# Загрузка изображений
content_img = load_image("content.jpg")
style_img = load_image("style.jpg")
target_img = content_img.clone().requires_grad_(True)

def get_features(image):
    features = {}
    x = image
    for name, layer in cnn.named_children():
        x = layer(x)
        if name in style_layers + [content_layer]:
            features[name] = x
    return features

# Оптимизатор
optimizer = optim.Adam([target_img], lr=LR) if USE_ADAM else optim.LBFGS([target_img])

for step in range(STEPS):
    def closure():
        optimizer.zero_grad()
        target_features = get_features(target_img)
        content_features = get_features(content_img)
        style_features = get_features(style_img)

        # Content loss
        content_loss = torch.mean((target_features[content_layer] - content_features[content_layer])**2)

        # Style loss (исправленная строка)
        style_loss = 0
        for layer in style_layers:
            style_loss += torch.mean((gram_matrix(target_features[layer]) - gram_matrix(style_features[layer]))**2)

        total_loss = content_loss + STYLE_WEIGHT * style_loss
        total_loss.backward()

        if step % 5 == 0:
            print(f"Step {step}/{STEPS} | Loss: {total_loss.item():.2f}")
        return total_loss

    optimizer.step(closure)

# Сохранение результата
result = transforms.ToPILImage()(target_img.detach().cpu().squeeze(0))
result.save("output_fast.jpg")
print("Готово! Результат сохранен как output_fast.jpg")
