---
paths: ["**/*.ipynb", "notebooks/**/*.ipynb", "research/**/*.ipynb"]
priority: 9
description: Jupyter notebook standards and best practices
tags: [notebooks, jupyter, python, data-science]
---

# Jupyter Notebook Standards

Guidelines for writing reproducible, well-organized Jupyter notebooks.

## Notebook Structure

Organize notebooks with clear sections using markdown headers:

```
# Analysis Title

## Overview
Brief description of notebook purpose and findings

## Setup
- Data sources
- Key libraries
- Assumptions

## Exploratory Data Analysis
- Data shape and types
- Missing values
- Distribution analysis

## Preprocessing
- Feature engineering
- Data cleaning
- Train/test split

## Modeling
- Model selection
- Training
- Evaluation

## Results
- Key findings
- Recommendations
- Next steps
```

## Code Standards

```python
# 1. Imports at top of notebook
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split

# 2. Set random seed for reproducibility
np.random.seed(42)

# 3. Load data with clear variable names
df_raw = pd.read_csv("data/raw_data.csv")
df_train, df_test = train_test_split(df_raw, test_size=0.2, random_state=42)

# 4. Add markdown explanations between code blocks
# Don't rely on implicit understanding
```

## Reproducibility

**Must include**:
- Python version and key library versions
- Random seeds (numpy, sklearn, etc.)
- Data source/download instructions
- Relative file paths (never hardcoded paths)
- Comment explaining non-obvious decisions

```python
# Cell 1: Environment setup
import sys
print(f"Python: {sys.version}")
import pandas; print(f"Pandas: {pandas.__version__}")
```

## Output & Results

- **Save models**: Use `joblib.dump()` for fitted models
- **Save predictions**: CSV with predictions and confidence scores
- **Save plots**: High resolution (DPI=300) PNG files
- **Document findings**: Markdown cells summarizing results

## Limitations

**Avoid**:
- Very long cells (split if > 50 lines)
- Cell execution order dependencies (run top-to-bottom)
- Hardcoded paths or credentials
- Large datasets embedded (use remote/git-lfs)
- Side effects without clear labeling

---

**Priority**: 9 (high priority)
**Tags**: notebooks, jupyter, python
**Applies To**: All `.ipynb` files
