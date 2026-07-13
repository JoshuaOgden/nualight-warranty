# Deploying the Portal free with GitHub Pages

This hosts the tool at a public URL like
`https://YOUR-USERNAME.github.io/nualight-warranty/` at no cost.

You only need to do steps 1–5 once. After that, updating the site is just
"edit the CSV → commit" (step 6).

---

## 1. Create a free GitHub account
Go to <https://github.com> and sign up (if Nualight doesn't already have an
organisation account you can use).

## 2. Create a new repository
- Click **+ → New repository**.
- Name it e.g. `nualight-warranty`.
- Set it to **Public** (required for free GitHub Pages).
- Do **not** add a README (we already have one).
- Click **Create repository**.

## 3. Push this folder to GitHub
GitHub will show a URL like `https://github.com/YOUR-USERNAME/nualight-warranty.git`.
Open PowerShell in this folder and run (replace the URL with yours):

```powershell
git remote add origin https://github.com/YOUR-USERNAME/nualight-warranty.git
git branch -M main
git push -u origin main
```

The first push will ask you to sign in to GitHub in your browser.

> The local git repository and first commit are already prepared for you — you
> only need the three commands above.

## 4. Turn on GitHub Pages
- In the repository, go to **Settings → Pages**.
- Under **Build and deployment → Source**, choose **Deploy from a branch**.
- Branch: **main**, folder: **/ (root)**. Click **Save**.

## 5. Get your URL
After ~1 minute, the Pages settings screen shows:
**"Your site is live at https://YOUR-USERNAME.github.io/nualight-warranty/"**

That is the address to put into your QR codes:
```
https://YOUR-USERNAME.github.io/nualight-warranty/?id=N14646 25182 V1549 0007
```

---

## 6. Updating the site later (adding products / recording claims)

**Easiest (no software):** on github.com, open `products.csv`, click the pencil
(Edit) icon, make your changes, and click **Commit changes**. The live site
updates within a minute.

**From your PC:** edit `products.csv` in Excel, save, then run:
```powershell
git add products.csv
git commit -m "Update product data"
git push
```

---

## Optional: custom domain
You can later point something like `warranty.nualight.com` at the site via
**Settings → Pages → Custom domain**. This needs a small DNS change by whoever
manages the nualight.com domain. Not required to go live.
