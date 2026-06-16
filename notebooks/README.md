# Notebooks

Exploratory analysis and research notebooks. Not for production use.

## Structure

| Notebook | Description |
|---|---|
| `01_data_exploration.ipynb` | Initial EDA on raw order book data |
| `02_feature_analysis.ipynb` | Feature distribution and correlation analysis |
| `03_market_impact.ipynb` | Market impact modelling experiments |
| `04_signal_research.ipynb` | Signal research and hypothesis testing |
| `05_backtest_analysis.ipynb` | Deep-dive into backtest results |

## Guidelines

- Keep notebooks in `notebooks/` and commit them with cleared outputs
- Use `nbstripout` pre-commit hook to strip output before committing
- Production code extracted from notebooks must live in `src/`
