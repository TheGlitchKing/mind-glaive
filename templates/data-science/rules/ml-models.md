---
paths: ["models/**/*.py", "src/models/**/*.py", "training/**/*.py"]
priority: 8
description: Machine learning model development and versioning standards
tags: [ml, models, training, python, sklearn]
---

# ML Model Development Standards

Guidelines for building, training, versioning, and evaluating machine learning models.

## Model Development Pattern

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score
import joblib

# 1. Initialize with reproducible settings
model = RandomForestClassifier(
    n_estimators=100,
    max_depth=10,
    random_state=42,
    n_jobs=-1
)

# 2. Train with clear parameter documentation
model.fit(X_train, y_train)

# 3. Evaluate on multiple metrics
predictions = model.predict(X_test)
metrics = {
    "accuracy": accuracy_score(y_test, predictions),
    "precision": precision_score(y_test, predictions),
    "recall": recall_score(y_test, predictions),
}

# 4. Save model with metadata
model_metadata = {
    "model_type": "RandomForest",
    "version": "1.0",
    "training_date": "2026-01-09",
    "test_metrics": metrics,
    "hyperparameters": model.get_params(),
}
joblib.dump(model, "models/model_v1.0.pkl")
```

## Model Versioning

Use semantic versioning for models:
- **MAJOR**: Architecture/algorithm change
- **MINOR**: Hyperparameter tuning
- **PATCH**: Bug fix or small improvement

Store:
- Model files: `models/model_{version}.pkl`
- Metadata: `models/model_{version}_metadata.json`
- Training log: `models/model_{version}_training.log`

## Evaluation Standards

Always report:
- **Baseline**: Simple model performance for comparison
- **Train/Test split**: Clearly separate training and evaluation
- **Cross-validation**: Use for small datasets
- **Multiple metrics**: Not just accuracy (precision, recall, F1, etc.)

```python
from sklearn.model_selection import cross_val_score

# Report cross-validation scores
cv_scores = cross_val_score(model, X_train, y_train, cv=5)
print(f"CV Score: {cv_scores.mean():.3f} (+/- {cv_scores.std():.3f})")
```

## Hyperparameter Tuning

- Document initial choices and rationale
- Use grid search or random search systematically
- Avoid overfitting to test set
- Report tuning results and final parameters

## Model Documentation

Every model must include:
- **Purpose**: What problem it solves
- **Data**: Training data characteristics
- **Hyperparameters**: All settings used
- **Performance**: Metrics on train/test/validation
- **Limitations**: When it fails or isn't recommended
- **Dependencies**: Python packages and versions

---

**Priority**: 8 (standard priority)
**Tags**: ml, models, training, python
**Applies To**: All model training code
