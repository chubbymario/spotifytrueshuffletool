# Playlist Shuffler

A small tool that logs into a Spotify account and **permanently reorders**
the tracks in a playlist you choose, into a fresh random order.

This is different from Spotify's built-in shuffle button. Spotify's shuffle
only randomizes *playback* order for one listening session — the playlist
itself never changes. This tool rewrites the playlist's actual track order,
so the new order sticks everywhere (desktop, phone, speakers, shared links)
until you shuffle again.

It's one file — `index.html` — with everything built in: no installer, no
app store, no dependencies. Because it's a normal web page, it runs
identically in Edge or Chrome on Windows 11 and in Safari on an iPhone
(including iOS 26). You set it up once and can use it from either device.

**Spotify Premium is not required.** Reordering a playlist's tracks is a
regular playlist-editing action, not a playback feature.

---

## How it works, in short

1. You click **Connect Spotify** and log in through Spotify's own website
   (this tool never sees or handles your Spotify password).
2. Spotify hands the tool a temporary access token, scoped to only
   reading and editing playlists — nothing else on your account.
3. You pick a playlist from a dropdown.
4. The tool downloads the list of track IDs in that playlist, shuffles that
   list in your browser, and writes the new order back to Spotify.

Everything happens directly between your browser and Spotify's servers.
There's no backend server of ours in the middle, and nothing about your
account is stored anywhere except your browser's temporary session memory
(cleared when you close the tab).

---

## What you need

- A free or Premium Spotify account.
- 10 minutes for one-time setup.
- **Windows 11:** any modern browser (Edge, Chrome, Firefox) — already installed.
- **iPhone (optional):** Safari, and a free place to host one HTML file
  (this guide uses GitHub Pages, which is free and takes about 5 minutes).

---

## Step 1 — Create a Spotify app (one-time)

Spotify requires every piece of software that uses its API to be registered,
even personal projects. This just gets you a **Client ID**.

1. Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) and log in with your Spotify account.
2. Click **Create app**.
3. Fill in the form:
   - **App name:** anything, e.g. `My Playlist Shuffler`
   - **App description:** anything, e.g. `Personal tool to shuffle my playlists`
   - **Redirect URIs:** add this one for now (you'll add a second one later if you set up iPhone access):
     ```
     http://127.0.0.1:5500/index.html
     ```
   - **Which API/SDKs are you planning to use?** check **Web API**.
4. Agree to the terms and click **Save**.
5. On the app's page, click **Settings** and copy the **Client ID** shown at the top. You'll need it in the next step.

You do *not* need the Client Secret for this tool — it's built to use a login
method (PKCE) designed specifically for apps, like this one, that can't
safely keep a secret hidden.

---

## Step 2 — Add your Client ID to the tool

1. Open `index.html` in any text editor (Notepad works fine).
2. Find this line near the top of the `<script>` section:
   ```js
   const CLIENT_ID = 'PASTE_YOUR_SPOTIFY_CLIENT_ID_HERE';
   ```
3. Replace the placeholder text with the Client ID you copied, keeping the quotes:
   ```js
   const CLIENT_ID = '1a2b3c4d5e6f7g8h9i0j...';
   ```
4. Save the file.

---

## Step 3 — Run it on Windows 11

Double-clicking `index.html` will open it in your browser, but Spotify's
login will fail from a page opened that way (it requires an `http://` or
`https://` address, not a raw file). The included script fixes this by
serving the folder over a local address.

1. Make sure **Python** is available. Open a Command Prompt and run `python --version`. If it's not installed, get it free from the [Microsoft Store](https://apps.microsoft.com/detail/9ncvdn91xzqp) (search "Python") — this is a one-time install.
2. Double-click **`start-local-server.bat`** in the project folder.
3. It opens `http://127.0.0.1:5500/index.html` in your browser automatically.
4. Click **Connect Spotify**, log in, and approve the permissions screen.
5. Leave the black command-window running in the background while you use the tool — closing it stops the local server. Closing it doesn't affect your Spotify account or playlists in any way.

If you'd rather not use Python, any other tool that serves static files over
HTTP works too (e.g. the "Live Server" extension in VS Code, or `npx
http-server` if you have Node.js installed) — just make sure the address it
serves matches whatever you registered as the Redirect URI in Step 1.

---

## Step 4 — Add access from an iPhone (optional)

To open the same tool on your iPhone, it needs to be hosted somewhere with a
real web address (a phone can't reach `127.0.0.1` on your PC). **GitHub
Pages** is a free, standard way to do this for a static file like this one.

1. Create a free account at [github.com](https://github.com) if you don't have one.
2. Create a new **public** repository (e.g. named `playlist-shuffler`).
3. Upload your edited `index.html` (the one with your Client ID already filled in) to that repository.
4. In the repository, go to **Settings → Pages**. Under "Build and deployment", set **Source** to **Deploy from a branch**, branch **main**, folder **/(root)**, then **Save**.
5. Wait about a minute, then refresh that settings page — it will show your live URL, something like:
   ```
   https://your-username.github.io/playlist-shuffler/
   ```
6. Go back to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) → your app → **Settings**, and add a **second** Redirect URI, exactly matching that URL with `index.html` on the end:
   ```
   https://your-username.github.io/playlist-shuffler/index.html
   ```
   Save the settings.
7. On your iPhone, open that same URL in Safari.
8. Optional but nice: tap the **Share** icon → **Add to Home Screen**, so it behaves like a regular app icon.

Your Windows setup (Step 3) and your iPhone/GitHub Pages setup (Step 4) are
two separate addresses pointing at the same code — that's why the app has
*two* registered Redirect URIs, one per address. You can use either or both.

> **Note:** anyone who knows your GitHub Pages URL could open the login
> screen, but they'd still need to log in with *their own* Spotify
> credentials to do anything — the tool only ever acts on whichever account
> is logged in at the time. If you'd rather keep it fully private, make the
> GitHub repository private and use GitHub Pages' access controls, or simply
> don't share the link.

---

## Using the tool

1. Open the app (locally on Windows, or your GitHub Pages link on iPhone).
2. Click/tap **Connect Spotify** and approve the permissions:
   - View your private and collaborative playlists
   - Edit your public and private playlists

   (These are the only two permissions requested — the tool can't see your
   listening history, saved songs, or anything else on your account.)
3. Choose a playlist from the dropdown. It lists every playlist you own or
   collaborate on, with its track count.
4. Click **Shuffle playlist**. The record icon spins while it works, and the
   activity log at the bottom shows progress.
5. When it finishes, the playlist is shuffled — open Spotify on any device
   to see the new order.

---

---

## Using it on iPhone: a note about backgrounding

iOS pauses a Safari tab's network activity and timers as soon as it's not the
one on screen — switching apps, locking your phone, or even swiping down for
Control Center can do it. If that happens mid-shuffle, you may see a
"Connection hiccup" message or a "Paused — this tab is in the background"
note in the activity log. Both are the tool detecting the interruption and
recovering automatically:

- A brief interruption resolves itself — the tool retries automatically and
  picks up where it left off within a few seconds of you returning to Safari.
- A longer interruption pauses cleanly and picks back up as soon as the tab
  is visible again — nothing is lost by leaving it paused.

The simplest way to avoid seeing this at all: **stay on the tab until the log
says "Done"** — it's usually a matter of seconds. If a shuffle does get
interrupted and shows an error, just tap **Shuffle playlist** again; both
methods the tool uses are safe to re-run and will finish the job correctly
from wherever the playlist currently stands.

---

## Good to know

- **Only your own or collaborative playlists can be shuffled.** Spotify's API only allows reading or editing the contents of a playlist you own or collaborate on. Playlists you just follow (a friend's playlist, an official Spotify playlist you saved, etc.) will show up elsewhere in Spotify but won't appear in this tool's dropdown, since Spotify would reject any attempt to edit them.
- **Local files are handled automatically.** If a playlist contains songs added from a phone or computer's own storage (rather than from Spotify's catalog), the tool detects them and automatically switches to a slower, one-track-at-a-time method that moves items instead of replacing the playlist outright — which is the only way Spotify's API allows local files to be touched at all. You'll see a note about this in the activity log when it happens, and for playlists with a couple hundred tracks or more, this method takes noticeably longer since it's roughly one request per track rather than one request per 100.
- **Collaborative playlists:** shuffling one changes the order for everyone
  who follows it, not just you.
- **Very large playlists (no local files):** Spotify's API accepts at most 100 tracks per
  request, so the tool sends the new order in batches. A 2,000-track
  playlist takes a bit longer (a handful of extra seconds) but works the
  same way.
- **Sessions:** you'll need to log in again if you don't use the tool for
  a while (Spotify's refresh tokens are long-lived, but the browser only
  remembers your session for as long as the tab stays open, by design — see
  "Security notes" below).

---

## Security notes

- This tool has no server of its own. Every request goes directly from your
  browser to `accounts.spotify.com` and `api.spotify.com`.
- Login uses OAuth's **Authorization Code with PKCE** flow — the modern
  standard for browser-based apps, used specifically because it avoids ever
  needing a client secret embedded in code the browser can see.
- Tokens are kept in the browser's `sessionStorage`, which is automatically
  wiped when the browser tab is closed — nothing is written to disk.
- The requested permissions (`playlist-read-private`,
  `playlist-read-collaborative`, `playlist-modify-public`,
  `playlist-modify-private`) only cover playlists — the tool cannot read or
  change anything else in your account.
- Because it's a single readable HTML file, you (or anyone) can open it in a
  text editor and see exactly what it does — there's nothing hidden.

---

## Troubleshooting

| Problem | Likely cause |
|---|---|
| "INVALID_CLIENT: Invalid redirect URI" after clicking Connect | The address in your browser's URL bar doesn't exactly match a Redirect URI registered in the Spotify Dashboard (including `http` vs `https`, and the trailing `/index.html`). |
| Nothing happens when opening `index.html` directly | You opened it as a `file://` address. Use `start-local-server.bat` (Windows) or your hosted GitHub Pages link (iPhone) instead. |
| "Could not complete sign-in" | Double check `CLIENT_ID` in `index.html` was pasted correctly, with no extra spaces or quotes. |
| Playlist list is empty, or shorter than you expected | The account you logged in with has no playlists, you're logged into a different account than expected, or some of your playlists are ones you follow rather than own/collaborate on (Spotify doesn't allow editing those — see "Good to know" above). |
| "403 Forbidden" when shuffling | You've likely selected (or the tool has somehow offered) a playlist you don't own or collaborate on. This shouldn't happen since those are filtered out automatically, but if it does, log out and back in to refresh the list. |
| Playlist list shows nothing and there's no error, or the app seems "stuck logged in" but nothing loads | Your session died quietly — most often from a token-renewal request getting interrupted while the tab was in the background. The tool now detects this and drops you back to a "Connect Spotify" screen with a short explanation; just log in again. |
| Shuffle stops partway with an error | Usually a temporary network issue or Spotify rate limiting — the tool already retries automatically, but you can also just click Shuffle again. |

---

## Files in this project

| File | Purpose |
|---|---|
| `index.html` | The entire app — UI, styling, and logic, fully commented. |
| `start-local-server.bat` | Windows convenience script to serve the app locally so Spotify login works. |
| `README.md` | This document. |
