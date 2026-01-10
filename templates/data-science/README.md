# Data Science Template

Complete CLAUDE.md structure for ML projects, data analysis, and research.

## When to Use

- Building machine learning models
- Jupyter notebook-based research
- Data analysis and exploration
- Experiment management and tracking
- Publishing research findings

## Contents

- `CLAUDE.md` - Data science structure with Experiments/Data/Analysis sections
- `rules/notebooks.md` - Jupyter notebook standards and best practices
- `rules/ml-models.md` - Model development, versioning, and evaluation

## Pre-Configured For

- Jupyter notebooks and JupyterLab
- scikit-learn, PyTorch, TensorFlow
- pandas, NumPy, SciPy
- Reproducible research practices
- Experiment tracking and versioning

## Customization

### Add Experiment Tracking
Add to CLAUDE.md:
```markdown
## Experiment Tracking

- Tool: MLflow (local) or W&B (cloud)
- Logging: Metrics, hyperparameters, artifacts
- Baseline: Initial model performance
```

### Add Data Pipeline Documentation
```markdown
## Data Pipeline

- Source: [data location]
- Preprocessing: [steps]
- Features: [key features]
- Splits: [train/test/validation]
```

### Add Model Registry
Link to model versions and performance.

## Size

- CLAUDE.md: ~2KB
- Rules: ~4KB total
- Target: < 30KB with notebooks linked externally

## Related Files

- Notebooks: `notebooks/` directory with clear naming
- Data: Document source and preprocessing
- Models: Store in `models/` with metadata
- Results: Archive completed experiments

**Created**: 2026-01-09
