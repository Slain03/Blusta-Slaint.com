#!/usr/bin/env bash
set -euo pipefail

ROOT="/tmp/blusta-slaint-project"
ZIPOUT="/tmp/blusta_slaint_full_project.zip"

# remove old
rm -rf "$ROOT"
rm -f "$ZIPOUT"

mkdir -p "$ROOT"

# Top level files
cat > "$ROOT/README.md" <<'MD'
Blusta-Slaint DeFi Wallet Starter
---------------------------------
This starter contains a Next.js frontend, Express backend, Hardhat smart-contracts, and docs.
Replace environment values in .env.example before running. Do NOT commit secret keys.
MD

cat > "$ROOT/LICENSE" <<'LIC'
MIT License

Copyright (c) 2025 SlainT
LIC

cat > "$ROOT/.gitignore" <<'GI'
node_modules
.env
.env.local
.next
dist
build
GI

########## Frontend (Next.js) ##########
FE="$ROOT/frontend"
mkdir -p "$FE/pages" "$FE/components" "$FE/lib" "$FE/styles"

cat > "$FE/package.json" <<'PJ'
{
  "name": "blusta-slaint-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "14.2.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "wagmi": "^1.4.0",
    "ethers": "^6.8.0",
    "@web3modal/react": "^2.8.0",
    "@web3modal/ethereum": "^2.8.0",
    "axios": "^1.5.0"
  }
}
PJ

cat > "$FE/.env.example" <<'ENV'
NEXT_PUBLIC_RPC_URL=https://bsc-dataseed.binance.org
NEXT_PUBLIC_CHAIN_ID=56
NEXT_PUBLIC_TOKEN_ADDRESS=0x5c047Dbf4D8C70d245732B9fda4653635EBa1858
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
NEXT_PUBLIC_1INCH_API_KEY=your_1inch_api_key_optional
ENV

cat > "$FE/pages/_app.js" <<'APP'
import '../styles/globals.css'
import { WagmiConfig, createConfig, configureChains } from 'wagmi'
import { bsc, mainnet } from 'wagmi/chains'
import { w3mProvider, w3mConnectors } from '@web3modal/ethereum'
import { Web3Modal } from '@web3modal/react'
import { EthereumClient } from '@web3modal/ethereum'

const projectId = process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'YOUR_WALLETCONNECT_PROJECT_ID'
const chains = [bsc, mainnet]
const { publicClient } = configureChains(chains, [w3mProvider({ projectId })])
const wagmiConfig = createConfig({
  autoConnect: true,
  connectors: w3mConnectors({ projectId, chains }),
  publicClient
})
const ethereumClient = new EthereumClient(wagmiConfig, chains)

export default function App({ Component, pageProps }) {
  return (
    <WagmiConfig config={wagmiConfig}>
      <Component {...pageProps} />
      <Web3Modal projectId={projectId} ethereumClient={ethereumClient} />
    </WagmiConfig>
  )
}
APP

cat > "$FE/pages/index.js" <<'IDX'
import Head from 'next/head'
import WalletConnectButton from '../components/WalletConnectButton'
import WalletSwapSLN from '../components/WalletSwapSLN'

export default function Home() {
  return (
    <>
      <Head>
        <title>Blusta-Slaint — DeFi Wallet</title>
        <meta name="description" content="Blusta-Slaint: Buy & Sell Crypto" />
      </Head>
      <main className="min-h-screen flex flex-col items-center justify-center p-8">
        <h1 className="text-3xl font-bold mb-6">Blusta-Slaint DeFi Wallet</h1>
        <WalletConnectButton />
        <div style={{width: '100%', maxWidth: 720, marginTop: 24}}>
          <WalletSwapSLN />
        </div>
      </main>
    </>
  )
}
IDX

cat > "$FE/styles/globals.css" <<'CSS'
html,body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial;line-height:1.5;margin:0;padding:0;background:#f6f8fb;color:#0f172a}
main{max-width:980px;margin:0 auto}
button{cursor:pointer}
CSS

cat > "$FE/components/WalletConnectButton.js" <<'WCB'
'use client';
import { useAccount, useBalance } from 'wagmi'
import { Web3Button } from '@web3modal/react'

export default function WalletConnectButton() {
  const { address, isConnected } = useAccount()
  const { data: balanceData } = useBalance({ address, watch: true })

  return (
    <div style={{display:'flex', flexDirection:'column', alignItems:'center'}}>
      <Web3Button />
      {isConnected && (
        <div style={{marginTop:12, textAlign:'center'}}>
          <div style={{fontSize:12, color:'#64748b'}}>Connected: {address?.slice(0,6)}...{address?.slice(-4)}</div>
          <div style={{fontSize:16, fontWeight:600}}>{balanceData?.formatted} {balanceData?.symbol}</div>
        </div>
      )}
    </div>
  )
}
WCB

cat > "$FE/components/WalletSwapSLN.js" <<'WS'
'use client'
import { useState } from 'react'
import { useAccount } from 'wagmi'
import { ethers } from 'ethers'

const SLN_ADDRESS = process.env.NEXT_PUBLIC_TOKEN_ADDRESS || '0x5c047Dbf4D8C70d245732B9fda4653635EBa1858'
const BSC_CHAIN_ID = 56

export default function WalletSwapSLN() {
  const { address, isConnected } = useAccount()
  const [fromToken, setFromToken] = useState('BNB')
  const [toToken, setToToken] = useState('SLN')
  const [amount, setAmount] = useState('')
  const [txHash, setTxHash] = useState(null)
  const [loading, setLoading] = useState(false)

  const handleSwap = async () => {
    if (!isConnected) return alert('Connect your wallet first.')
    if (!amount) return alert('Enter amount to swap.')

    try {
      setLoading(true)
      const provider = new ethers.BrowserProvider(window.ethereum)
      const signer = await provider.getSigner()
      const fromTokenAddress = fromToken === 'BNB' ? '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE' : fromToken
      const toTokenAddress = toToken === 'SLN' ? SLN_ADDRESS : toToken
      const decimals = 18
      const amountWei = ethers.parseUnits(amount, decimals).toString()
      const quoteUrl = `https://api.1inch.io/v5.0/${BSC_CHAIN_ID}/swap?fromTokenAddress=${fromTokenAddress}&toTokenAddress=${toTokenAddress}&amount=${amountWei}&fromAddress=${address}&slippage=1`
      const response = await fetch(quoteUrl)
      const data = await response.json()
      if (!data.tx) {
        alert('Swap quote failed. Check token addresses or network.')
        setLoading(false)
        return
      }
      const txParams = {
        to: data.tx.to,
        data: data.tx.data,
      }
      if (data.tx.value) txParams.value = ethers.parseEther(amount).toString()
      const tx = await signer.sendTransaction(txParams)
      setTxHash(tx.hash)
      setLoading(false)
    } catch (err) {
      console.error(err)
      alert('Swap failed. See console for details.')
      setLoading(false)
    }
  }

  return (
    <div style={{background:'#fff', padding:20, borderRadius:12}}>
      <h3 style={{marginBottom:12}}>Swap Any Token ⇄ SLN</h3>
      <input placeholder="Amount" value={amount} onChange={(e)=>setAmount(e.target.value)} style={{width:'100%', padding:8, marginBottom:8}} />
      <input placeholder="From Token Address or Symbol (e.g. BNB or 0x...)" value={fromToken} onChange={(e)=>setFromToken(e.target.value)} style={{width:'100%', padding:8, marginBottom:8}} />
      <input placeholder="To Token (SLN or token addr)" value={toToken} onChange={(e)=>setToToken(e.target.value)} style={{width:'100%', padding:8, marginBottom:12}} />
      <button onClick={handleSwap} style={{width:'100%', padding:10, background:'#0366ff', color:'#fff', borderRadius:8}} disabled={loading}>{loading?'Swapping...':'Swap'}</button>
      {txHash && <div style={{marginTop:12, color:'#16a34a'}}>✅ Swap sent! Tx: <a href={`https://bscscan.com/tx/${txHash}`} target="_blank">{txHash.slice(0,12)}...</a></div>}
    </div>
  )
}
WS

cat > "$FE/lib/web3.js" <<'W3'
import { ethers } from 'ethers'
export const connectWallet = async () => {
  if (typeof window === 'undefined') throw new Error('Browser-only function')
  if (!window.ethereum) throw new Error('MetaMask not detected')
  const provider = new ethers.BrowserProvider(window.ethereum)
  await provider.send('eth_requestAccounts', [])
  const signer = await provider.getSigner()
  return signer
}
W3

########## Backend (Express) ##########
BE="$ROOT/backend"
mkdir -p "$ROOT/backend"
cat > "$ROOT/backend/package.json" <<'BPJ'
{
  "name": "blusta-slaint-backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {"start": "node server.js"},
  "dependencies": {"express": "^4.18.2", "cors": "^2.8.5"}
}
BPJ

cat > "$ROOT/backend/server.js" <<'BS'
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors()); app.use(express.json());
app.get('/', (req, res) => res.send('Blusta-Slaint Backend OK'));
app.listen(4000, ()=> console.log('API listening on port 4000'));
BS

########## Smart contracts (Hardhat) ##########
SC="$ROOT/smart-contracts"
mkdir -p "$SC"
cat > "$SC/SlainTToken.sol" <<'SOLS'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SlainTToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("SlainT", "SLN") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
SOLS

cat > "$SC/hardhat.config.js" <<'HHT'
require('@nomicfoundation/hardhat-toolbox');
module.exports = {
  solidity: '0.8.24',
  networks: {
    bsc: {
      url: 'https://bsc-dataseed.binance.org/',
      accounts: ['YOUR_PRIVATE_KEY']
    }
  }
};
HHT

cat > "$SC/scripts/deploy.js" <<'DEP'
async function main() {
  const SlainT = await ethers.getContractFactory('SlainTToken');
  const deployed = await SlainT.deploy(1000000);
  console.log('SlainT deployed to:', deployed.address);
}
module.exports = main;
DEP

########## Config and docs ##########
mkdir -p "$ROOT/config" "$ROOT/docs"
cat > "$ROOT/config/chains.json" <<'CJ'
{
  "bsc": {"chainId": 56, "rpc": "https://bsc-dataseed.binance.org"},
  "ethereum": {"chainId": 1, "rpc": "https://mainnet.infura.io/v3/YOUR_KEY"}
}
CJ

# If a PDF from earlier exists in /mnt/data, include it; otherwise include placeholder
PDF_SRC="/mnt/data/Blusta_Slaint_DeFi_Wallet_Guide.pdf"
if [ -f "$PDF_SRC" ]; then
  cp "$PDF_SRC" "$ROOT/docs/Blusta_Slaint_DeFi_Wallet_Guide.pdf"
else
  echo "DeFi Wallet Guide PDF placeholder" > "$ROOT/docs/Blusta_Slaint_DeFi_Wallet_Guide.pdf"
fi

# Create zip
cd /tmp
zip -r "$ZIPOUT" "$(basename "$ROOT")" -x "*.DS_Store"

echo "Created ZIP: $ZIPOUT"
