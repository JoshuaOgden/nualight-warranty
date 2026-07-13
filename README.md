# Nualight Product ID Portal

A free, static web tool that shows a customer the warranty status of a Nualight
product when they scan its QR code (or type in the Product ID). Everything runs
in the browser — no server, no running costs.

---

## How it works

1. Each product label has a QR code pointing to:
   `https://YOUR-SITE/?id=<PRODUCT ID>`
2. The page reads `products.csv` (your database), finds that ID, and shows the
   product details + warranty status.
3. Status is decided like this:
   - If the row's **warranty_status** says `Claimed` or `Void` → that is shown.
   - Otherwise it is calculated: **ship/manufacture date + warranty_years**.
     After that date it shows **Expired**, within 90 days of it **Expiring Soon**,
     otherwise **Active**.
4. IDs that are **not** in `products.csv` show a "not found" message. This stops
   made-up IDs from ever showing as under warranty.

---

## Editing the database (`products.csv`)

Open `products.csv` in Excel. Each row = one product. Columns:

| Column              | Required | Notes                                                                 |
|---------------------|----------|-----------------------------------------------------------------------|
| `product_id`        | Yes      | Full ID exactly as printed, e.g. `N14646 25182 V1549 0007`. Spaces and capitalisation don't matter for matching. |
| `sku`               | Yes      | Part number, e.g. `N14646`.                                           |
| `description`       | Yes      | e.g. `ION V CHILLER 1676 E 4000K Vivace`.                             |
| `webpage_url`       | No       | Link behind the "Webpage" text.                                       |
| `product_photo`     | No       | Image file, e.g. `assets/product-N14646.png`. Falls back to a placeholder if blank/missing. |
| `install_guide_url` | No       | PDF for the "Install Guide" button, e.g. `assets/install-guide-N14646.pdf`. |
| `ship_date`         | No       | `YYYY-MM-DD` (recommended) or `DD/MM/YYYY`. **If left blank, the date is read automatically from the date code in the Product ID** (the `25182` part = 2025, day 182). |
| `warranty_years`    | No       | Defaults to 5 if blank.                                               |
| `warranty_status`   | No       | Leave **blank** for normal (auto Active/Expired). Set to `Claimed` or `Void` to override. |
| `claim_date`        | No       | e.g. `2026-05-02`. Shown when status is `Claimed`.                    |
| `claim_reference`   | No       | e.g. `WC-2026-0042`. Shown when status is `Claimed`.                  |

### To add a new product
Add a new row with at least `product_id`, `sku`, `description`. Save. Deploy (below).

### To record a warranty claim
Find the product's row, set **warranty_status** to `Claimed`, and fill in
`claim_date` and `claim_reference`. Save and deploy. The page will now show
"Claimed" for that unit.

> **Excel tip:** keep `ship_date` as text like `2025-09-25`. If Excel insists on
> reformatting it to `25/09/2025` that's fine too — the page understands both.

---

## Adding product photos & install guides

Put files in the `assets/` folder and point the CSV columns at them:
- Photo:  `assets/product-N14646.png`  →  `product_photo` column
- Guide:  `assets/install-guide-N14646.pdf`  →  `install_guide_url` column

Different products can share or use different photos/guides — just change the
filename in that product's row.

## Using the real company logo

The header/footer currently use `assets/logo.svg` (a stand-in). To use the
official logo, save the real image as **`assets/logo.png`** in the `assets`
folder — the page automatically uses it if present.

---

## QR codes

Point each QR code at:

```
https://YOUR-SITE/?id=N14646 25182 V1549 0007
```

Any QR generator works. The scanner opens the page with that product already
looked up and its warranty status showing.

---

## Testing locally (on this PC)

Double-click `serve.ps1` won't work directly; instead open PowerShell in this
folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
```

Then open <http://localhost:8791/>. (Opening `index.html` straight from disk
will NOT load the database — browsers block file reads over `file://`, so the
little local server above is needed for testing.)

---

## Deploying free with GitHub Pages

See `DEPLOY.md` for step-by-step instructions.

---

## Limitations (by design, to stay free)

- The "Claim Warranty" button opens a pre-filled email to `sales@nualight.com`.
  Recording the claim in the database is a manual step (set `warranty_status` to
  `Claimed`). A self-service claim form that writes to the database automatically
  would require a paid backend.
- Updating data = editing `products.csv` and re-deploying (a few clicks on
  GitHub, see `DEPLOY.md`).
