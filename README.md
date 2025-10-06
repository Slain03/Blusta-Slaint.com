# SlainT (SLN) — DeFi Dashboard  
**From Lesotho to the world. Empowering decentralized finance with heritage and innovation.**

![SlainT Banner](assets/images/slaint-banner.png)

---

## 🌍 Overview

**SlainT (SLN)** is a decentralized finance platform built to connect users with the power of blockchain — originating proudly from **Lesotho**.  
The platform offers a simple, secure, and transparent way to **buy, stake, swap, and track SLN tokens** on the **Binance Smart Chain (BSC)** network.

This repository hosts the **SlainT Web Dashboard**, a static site built with **HTML**, **TailwindCSS**, and **Ethers.js**, deployable via **Vercel**.

---

## ✨ Key Features

- 🏦 **DeFi Dashboard** — Real-time SLN price, wallet balance, and token stats.  
- 💱 **Swap & Trade** — Quick links to PancakeSwap with prefilled contract address.  
- 💧 **Liquidity Pools** — Future integration for users to add/remove liquidity.  
- 💰 **Staking System** — Planned reward model for long-term SLN holders.  
- 🛡️ **Secure Login** — Admin and User panels with password authentication.  
- 🇱🇸 **Lesotho Pride Theme** — Inspired by the national flag and local innovation.

---

## ⚙️ Tech Stack

| Layer | Technology |
|-------|-------------|
| Frontend | HTML, TailwindCSS, JavaScript (ES6) |
| Blockchain | Binance Smart Chain (BEP-20 Token) |
| Wallet Integration | MetaMask + Ethers.js |
| Hosting | [Vercel](https://vercel.com) |
| Database | [Supabase](https://supabase.com) *(optional, for user data)* |
| Domain | [BluSta.SlainT.com](https://BluSta.SlainT.com) *(planned)* |

---

## 🔗 Smart Contract

- **Token Name:** SlainT  
- **Symbol:** SLN  
- **Contract Address:** [`0x5c047Dbf4D8C70d245732B9fda4653635EBa1858`](https://bscscan.com/token/0x5c047Dbf4D8C70d245732B9fda4653635EBa1858)  
- **Network:** Binance Smart Chain (BSC)

---

## 🚀 Deployment (Vercel)

### 1️⃣ Clone this Repository
```bash
git clone https://github.com/YourUsername/SlainT-Platform.git
cd SlainT-Platform
```

### 2️⃣ Deploy on Vercel
- Go to [Vercel Dashboard](https://vercel.com/dashboard)
- Click **“Add New Project”**
- Import this GitHub repository
- Framework Preset → **Other**
- Build Command → *(leave blank)*
- Output Directory → `.`
- Click **Deploy**

### 3️⃣ Access your dashboard  
Once deployed, your site will be live at:
```
https://your-vercel-domain.vercel.app
```
You can later map it to:
```
https://BluSta.SlainT.com
```

---

## 🔐 Admin Login

| Role | Username | Password |
|------|-----------|----------|
| Admin | `SlainTmaster` | `Cooly$1920` |

> Default credentials — change them in `/admin/script.js` before going live.

---

## 🧩 Folder Structure

```
SlainT-Platform/
├── index.html               # Main dashboard (DeFi UI)
├── admin/                   # Admin control panel
│   └── index.html
├── user/                    # User dashboard
│   └── index.html
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
├── README.md
└── .gitignore
```

---

## 🧠 Roadmap

- [x] Core DeFi Dashboard  
- [x] Lesotho Pride Theme  
- [x] Admin/User login pages  
- [ ] Swap fees to creator wallet  
- [ ] Pool & staking integration  
- [ ] Supabase user storage  
- [ ] DEX and NFT marketplace integration  

---

## ❤️ Credits

- **Project Founder:** [Katiso Seipati](https://github.com/YourUsername)  
- **Token:** SlainT (SLN)  
- **Network:** Binance Smart Chain  
- **Theme:** Lesotho Heritage — Mountains, Unity & Growth  

---

## 📜 License

Released under the [MIT License](LICENSE).  
You are free to use, modify, and share this project with proper attribution.

---

> _"From Lesotho to the World — SlainT stands for unity, innovation, and community-driven success."_
