# Feature Catalogue

All features are computed from live order book state and persisted in the feature store.

## Spread Features (`features/spread.py`)

| Feature | Formula | Description |
|---|---|---|
| `raw_spread` | ask₁ − bid₁ | Nominal bid-ask spread |
| `relative_spread` | raw_spread / mid | Spread as fraction of mid-price |
| `effective_spread` | 2 × |trade_price − mid| | Realised cost of a trade |

## Imbalance Features (`features/imbalance.py`)

| Feature | Formula | Description |
|---|---|---|
| `order_imbalance` | (bid_qty − ask_qty) / (bid_qty + ask_qty) | Signed quantity imbalance at level 1 |
| `volume_imbalance_N` | Sum of top-N bid qty vs ask qty | Depth-weighted imbalance |

## Price Features (`features/microprice.py`)

| Feature | Formula | Description |
|---|---|---|
| `mid_price` | (ask₁ + bid₁) / 2 | Simple mid-price |
| `microprice` | Quantity-weighted mid | Qty-weighted mid-price (Stoikov) |

## Liquidity Features (`features/liquidity.py`)

| Feature | Description |
|---|---|
| `bid_depth_N` | Total bid quantity in top-N levels |
| `ask_depth_N` | Total ask quantity in top-N levels |
| `market_impact_1bps` | Estimated quantity to move price by 1 bps |

## Trade Flow Features (`features/trade_flow.py`)

| Feature | Description |
|---|---|
| `trade_intensity` | Trades per second in rolling window |
| `aggressor_ratio` | Fraction of buyer-initiated trades |
| `tick_direction` | Lee-Ready tick rule direction |

## Volatility Features (`features/volatility.py`)

| Feature | Description |
|---|---|
| `realised_variance` | Sum of squared log-returns in window |
| `parkinson_hl` | High-low range estimator |
