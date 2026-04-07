# 🏗️ Architecture — NLP Transformers

## 🧱 Proje Yapısı
```
project/
├── data/
│   ├── raw/              → Orijinal text verileri
│   ├── processed/        → Tokenize edilmiş veri
│   └── splits/           → train.csv, val.csv, test.csv
├── src/
│   ├── data/
│   │   ├── dataset.py    → HF Dataset oluşturma
│   │   │                   datasets.load_dataset / from_csv
│   │   └── tokenize.py   → AutoTokenizer ile tokenization
│   │                       padding, truncation, max_length
│   ├── models/
│   │   ├── model.py      → AutoModelForSequenceClassification / etc.
│   │   └── config.py     → Model config, hyperparameters
│   ├── training/
│   │   ├── trainer.py    → HF Trainer API ile eğitim
│   │   │                   TrainingArguments, callbacks
│   │   └── peft.py       → LoRA / QLoRA fine-tuning (PEFT)
│   ├── evaluation/
│   │   └── evaluate.py   → evaluate library (accuracy, f1, rouge)
│   └── inference/
│       ├── predict.py    → pipeline('text-classification')
│       └── gradio_app.py → Gradio demo UI
├── configs/
├── notebooks/ (eda, training, evaluation)
├── models/               → Fine-tuned model checkpoints
├── logs/
├── train.py, predict.py
├── requirements.txt
└── README.md
```

## NLP Task Types
| Task | Model | HF Class |
|------|-------|----------|
| Text Classification | BERT, DistilBERT | AutoModelForSequenceClassification |
| NER | BERT, RoBERTa | AutoModelForTokenClassification |
| Summarization | T5, BART, Pegasus | AutoModelForSeq2SeqLM |
| Question Answering | BERT, DeBERTa | AutoModelForQuestionAnswering |
| Text Generation | GPT-2, LLaMA, Mistral | AutoModelForCausalLM |
| Translation | mBART, MarianMT | AutoModelForSeq2SeqLM |

## Fine-Tuning Pipeline
```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification, Trainer, TrainingArguments

tokenizer = AutoTokenizer.from_pretrained('bert-base-uncased')
model = AutoModelForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=2)

def tokenize_fn(examples):
    return tokenizer(examples['text'], padding='max_length', truncation=True, max_length=512)

tokenized = dataset.map(tokenize_fn, batched=True)

training_args = TrainingArguments(
    output_dir='./results', num_train_epochs=3, per_device_train_batch_size=16,
    evaluation_strategy='epoch', save_strategy='epoch', load_best_model_at_end=True,
    metric_for_best_model='f1', learning_rate=2e-5, weight_decay=0.01)

trainer = Trainer(model=model, args=training_args, train_dataset=tokenized['train'],
                  eval_dataset=tokenized['val'], compute_metrics=compute_metrics)
trainer.train()
```

## LoRA Fine-Tuning (Büyük Modeller)
```python
from peft import LoraConfig, get_peft_model, TaskType
lora_config = LoraConfig(r=16, lora_alpha=32, target_modules=['q_proj','v_proj'],
                          task_type=TaskType.SEQ_CLS, lora_dropout=0.1)
model = get_peft_model(model, lora_config)
model.print_trainable_parameters()  # << %1-5 arası
```
