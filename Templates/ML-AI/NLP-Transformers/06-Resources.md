# 📚 Resources — NLP Transformers
| Kaynak | Link |
|--------|------|
| HuggingFace | https://huggingface.co |
| Transformers Docs | https://huggingface.co/docs/transformers |
| PEFT/LoRA | https://huggingface.co/docs/peft |
| HF Model Hub | https://huggingface.co/models |
| Gradio | https://gradio.app |
| HF Course | https://huggingface.co/learn |

## Gradio Demo
```python
import gradio as gr
from transformers import pipeline
classifier = pipeline('text-classification', model='./models/best')
def predict(text): return classifier(text)[0]
demo = gr.Interface(fn=predict, inputs="text", outputs="label")
demo.launch()
```
