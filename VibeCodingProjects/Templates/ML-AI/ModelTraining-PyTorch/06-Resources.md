# 📚 Resources — PyTorch

## 🔗 Dokümantasyon
| Kaynak | Link |
|--------|------|
| PyTorch | https://pytorch.org/docs |
| PyTorch Tutorials | https://pytorch.org/tutorials |
| PyTorch Lightning | https://lightning.ai/docs |
| TorchVision | https://pytorch.org/vision |
| Albumentations | https://albumentations.ai |
| W&B | https://docs.wandb.ai |
| ONNX | https://onnx.ai |
| Papers with Code | https://paperswithcode.com |

## 📌 Snippets

### Training Loop (Best Practice)
```python
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model.to(device)
scaler = torch.cuda.amp.GradScaler()  # Mixed precision

for epoch in range(epochs):
    model.train()
    epoch_loss = 0
    for batch in train_loader:
        inputs, targets = batch['x'].to(device), batch['y'].to(device)
        optimizer.zero_grad()
        with torch.cuda.amp.autocast():
            outputs = model(inputs)
            loss = criterion(outputs, targets)
        scaler.scale(loss).backward()
        scaler.unscale_(optimizer)
        torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
        scaler.step(optimizer)
        scaler.update()
        epoch_loss += loss.item()
    
    # Validation
    model.eval()
    val_loss = 0
    with torch.no_grad():
        for batch in val_loader:
            outputs = model(batch['x'].to(device))
            val_loss += criterion(outputs, batch['y'].to(device)).item()
    
    print(f"Epoch {epoch}: Train={epoch_loss/len(train_loader):.4f}, Val={val_loss/len(val_loader):.4f}")
    
    # Checkpoint
    if val_loss < best_val_loss:
        best_val_loss = val_loss
        torch.save(model.state_dict(), 'checkpoints/best.pt')
```

### Model Export (ONNX)
```python
dummy_input = torch.randn(1, 3, 224, 224).to(device)
torch.onnx.export(model, dummy_input, "model.onnx",
                  input_names=['input'], output_names=['output'],
                  dynamic_axes={'input': {0: 'batch'}, 'output': {0: 'batch'}})
```

### Seed (Reproducibility)
```python
def set_seed(seed=42):
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)
    torch.backends.cudnn.deterministic = True
```

### CLI
```bash
python -m venv venv && venv\Scripts\activate
pip install torch torchvision numpy pandas matplotlib scikit-learn
python train.py --epochs 100 --lr 1e-3 --batch_size 32
tensorboard --logdir=logs
python predict.py --model checkpoints/best.pt --input test_image.jpg
```
