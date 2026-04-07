# Starter Blueprints — ML/AI Templates

## ModelTraining-PyTorch
```
data/raw/, processed/, train/, val/, test/
src/
├── config.py → hyperparameters, paths
├── dataset.py → custom Dataset class
├── model.py → nn.Module
├── train.py → training loop, loss, optimizer, scheduler
├── evaluate.py → metrics, confusion matrix
├── predict.py → inference
├── utils.py → save/load model, plot
notebooks/EDA.ipynb
models/best_model.pth
requirements.txt → torch, torchvision, scikit-learn, matplotlib, tqdm
```

## ModelTraining-TensorFlow
```
data/raw/, processed/
src/
├── config.py
├── data_loader.py → tf.data pipeline
├── model.py → tf.keras.Model / Sequential
├── train.py → model.compile(), model.fit(), callbacks
├── evaluate.py → classification_report, confusion_matrix
├── predict.py
├── utils.py
models/saved_model/, model.h5
requirements.txt → tensorflow, scikit-learn, matplotlib, pandas
```

## ComputerVision-YOLO
```
data/
├── images/train/, val/
├── labels/train/, val/ (YOLO format: class x y w h)
├── data.yaml → nc, names, paths
src/
├── train.py → model = YOLO(); model.train()
├── detect.py → model.predict(source)
├── export.py → model.export(format='onnx')
├── api.py → FastAPI + YOLO inference endpoint
├── utils.py → annotation helpers
requirements.txt → ultralytics, fastapi, uvicorn, opencv-python
```

## NLP-Transformers
```
data/train.csv, val.csv, test.csv
src/
├── config.py → model_name, max_length, batch_size, epochs
├── dataset.py → HuggingFace Dataset / custom
├── train.py → Trainer, TrainingArguments
├── evaluate.py → accuracy, f1, classification_report
├── predict.py → pipeline()
├── api.py → FastAPI + Gradio inference
requirements.txt → transformers, datasets, evaluate, accelerate, peft, gradio
```
