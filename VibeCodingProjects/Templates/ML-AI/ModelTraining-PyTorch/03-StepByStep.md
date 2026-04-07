# 📝 Step-by-Step — PyTorch | 📂 Files | 🐛 Debug | 📚 Resources

## Adımlar
1. [ ] Venv + `pip install torch numpy pandas matplotlib`
2. [ ] EDA notebook → veriyi keşfet
3. [ ] Dataset sınıfı → `__getitem__`, transforms
4. [ ] DataLoader → train/val/test split
5. [ ] Model tanımla → `nn.Module`
6. [ ] Training loop → loss, optimizer, scheduler
7. [ ] Validation → metrics (accuracy, F1, etc.)
8. [ ] Checkpoint kaydet → `torch.save(model.state_dict(), 'best.pt')`
9. [ ] Inference → predict.py
10. [ ] Export → ONNX / TorchScript

## Debug Tips
- **CUDA out of memory** → batch size küçült, `torch.cuda.empty_cache()`
- **Loss NaN** → learning rate çok yüksek, gradient clipping ekle
- **Shape mismatch** → `print(tensor.shape)` her katmandan sonra
- **Slow training** → `num_workers > 0` DataLoader'da, `pin_memory=True`
- **Model overfitting** → dropout, augmentation, early stopping
- Araç: **TensorBoard** (`tensorboard --logdir=logs`), **W&B**, `print()`, `breakpoint()`

## Resources
| Kaynak | Link |
|--------|------|
| PyTorch | https://pytorch.org |
| PyTorch Lightning | https://lightning.ai |
| TorchVision | https://pytorch.org/vision |
| W&B | https://wandb.ai |
| Papers with Code | https://paperswithcode.com |

### CLI
```bash
python -m venv venv && venv\Scripts\activate
pip install torch torchvision pandas numpy matplotlib
python train.py --epochs 50 --lr 0.001 --batch_size 32
tensorboard --logdir=logs
```
