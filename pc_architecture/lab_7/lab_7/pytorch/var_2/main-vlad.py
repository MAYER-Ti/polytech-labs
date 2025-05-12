import torch
from torchvision import transforms
from PIL import Image
import matplotlib.pyplot as plt
import os

# ========== НАСТРОЙКИ ==========
MODEL_PATH = "generator_Hayao.pth"
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
INPUT_IMAGE = "input.jpg"
OUTPUT_IMAGE = "output.jpg"
IMAGE_SIZE = 512  # можно менять

# ========== ЗАГРУЗКА МОДЕЛИ ==========
class Generator(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.main = torch.hub.load('mnicnc404/CartoonGAN-Test-Pytorch-Torch', 'generator', model='Hayao', pretrained=False)

    def forward(self, x):
        return self.main(x)

print("Загрузка модели...")
model = Generator().to(DEVICE)
model.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
model.eval()

# ========== ПРЕОБРАЗОВАНИЯ ==========
transform = transforms.Compose([
    transforms.Resize((IMAGE_SIZE, IMAGE_SIZE)),
    transforms.ToTensor()
])

# ========== ЗАГРУЗКА ИЗОБРАЖЕНИЯ ==========
def load_image(path):
    image = Image.open(path).convert("RGB")
    return transform(image).unsqueeze(0).to(DEVICE)

def save_image(tensor, path):
    image = tensor.squeeze(0).cpu().clamp(0, 1)
    image = transforms.ToPILImage()(image)
    image.save(path)

# ========== СТИЛИЗАЦИЯ ==========
print("Загрузка изображения...")
img = load_image(INPUT_IMAGE)

print("Стилизация...")
with torch.no_grad():
    output = model(img)

print("Сохранение результата...")
save_image(output, OUTPUT_IMAGE)

# ========== ВИЗУАЛИЗАЦИЯ ==========
plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.imshow(Image.open(INPUT_IMAGE))
plt.title("Оригинал")
plt.axis("off")

plt.subplot(1, 2, 2)
plt.imshow(Image.open(OUTPUT_IMAGE))
plt.title("Стилизовано")
plt.axis("off")

plt.tight_layout()
plt.show()
