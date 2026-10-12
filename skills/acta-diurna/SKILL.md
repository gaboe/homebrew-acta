---
name: acta-diurna
description: Acta Diurna records Google Meet calls locally and writes speaker-labelled transcripts. Use to install or set up Acta, to add or check a licence, to read a meeting transcript, to turn a meeting into tasks and carry them out, to follow live requests during a call, or to diagnose a failed recording.
metadata:
  status: macos-verified-windows-0.1.21-verified
---

# Acta Diurna

Acta Diurna is a local application and Chrome extension. Together they record a Google Meet call, transcribe it on the user's computer, and store a Markdown transcript with speaker names and timestamps. The agent reads that transcript with the `acta` CLI and works with it alongside the project context it already has.

Start with **Setup** when `acta` is missing, has no valid licence, or the user asks to install it. Otherwise go to **Work with meetings**.

## Setup

macOS on Apple Silicon is verified. Windows x64 0.1.21 was verified on Windows 11 on 2026-10-12: install without admin rights, background service, Meet capture and the final transcript, with no workarounds. 0.1.22 fixes the smaller findings of that test and has not run on Windows yet. Intel Macs and Windows ARM are unsupported. Both platforms use Google Meet in Chrome and the published Chrome extension.

### Installation gate

Inspect the operating system, CPU architecture, and whether `acta` is already installed. Report those findings. On macOS Apple Silicon, follow the macOS procedure. On Windows x64, say that 0.1.21 was verified there and 0.1.22 not yet, and follow the Windows procedure. For an unsupported platform, report the missing build and stop. Use the published packages and instructions below.

| Distribution detail | Current value |
| --- | --- |
| Public Homebrew tap / release | [`gaboe/acta`](https://github.com/gaboe/homebrew-acta), public release [`v0.1.22`](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.22). arm64 artifact `acta-0.1.22-arm64.tar.gz`, SHA-256 `6ab944ee5c29ef08ab70c0c765a08bfd40d284821646bc0c85df479b2bd20303`; Windows x64 artifact `acta-0.1.22-x64.zip`, SHA-256 `1cef69b5e1e6b4c7092ee0adbdefdf32ab6923baa059209963d01db52648a2a8`. Built by CI run `38284796033` on 2026-10-12; the hashes match its downloaded artifacts. |
| macOS Apple Silicon installer | Homebrew tap `gaboe/acta`, formula `acta`; use the verified procedure below. There is no separate installer URL. |
| macOS installation procedure | Verified today: `brew trust gaboe/acta`, `brew tap gaboe/acta`, `brew install acta`, `acta setup`; `brew trust` must come first. |
| Windows x64 installer | Published. 0.1.21 was verified on Windows 11; 0.1.22 has not run on Windows. `acta-0.1.22-x64.zip` is on the same release as the macOS tarball, built by the repository's release workflow on a `windows-latest` runner and confirmed to be a PE32+ console executable. The Scoop manifest is at `https://raw.githubusercontent.com/gaboe/homebrew-acta/main/scoop/acta.json`. Only x64; there is no Windows-on-ARM build. |
| Windows installation procedure | Follow the Windows x64 procedure below. Scoop installs ffmpeg; install whisper-cli separately. `acta serve --install` adds a per-user logon entry without admin rights. |
| Chrome extension distribution | [Chrome Web Store listing](https://chromewebstore.google.com/detail/iidpmegkbdilgbmglnnfealgicfjnglc), unlisted and reachable by this link. Extension 0.1.22 fixes the last archive chunk lost on every stop; it was submitted to the Store on 2026-10-12 and is in review, so the listing may still serve 0.1.19. CLI 0.1.22 rescues the archive of a 0.1.19 capture missing only that chunk. The release also carries the 0.1.22 unpacked ZIP. Store and unpacked installations share the same extension id, so use only one at a time. |

### macOS Apple Silicon procedure

Run these commands in order:

```sh
brew trust gaboe/acta
brew tap gaboe/acta
brew install acta
acta setup
```

`brew trust` is required. If Homebrew reports `invalid syntax in tap!`, that message is misleading: the third-party tap was not trusted yet. Run the trust command first; do not report a broken formula. `acta setup` downloads the Whisper model. It is large and only needs to happen once.

### Windows x64 procedure

Verify each command's result before continuing.

1. Install Acta and its ffmpeg dependency. With Scoop:

   ```powershell
   scoop install https://raw.githubusercontent.com/gaboe/homebrew-acta/main/scoop/acta.json
   acta --version
   ffmpeg -version
   ```

   Without Scoop, install by hand. Scoop is not on Windows by default, and its installer pipes a downloaded script into PowerShell, which many agents refuse to run. Download `acta-0.1.22-x64.zip` from the [public release](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.22) and check its SHA-256 against the distribution table. Extract it to `%LOCALAPPDATA%\Programs\acta` and add that folder to the user's PATH. Install ffmpeg with `winget install Gyan.FFmpeg` if `ffmpeg -version` fails. Open a new PowerShell window and run the two version checks above.

2. Download `whisper-bin-x64.zip` from the [official whisper.cpp binary release b5130](https://github.com/ggml-org/whisper.cpp/releases/tag/b5130). This CPU build does not require CUDA. On a machine with an NVIDIA GPU, offer `whisper-cublas-12.4.0-bin-x64.zip` from the same release instead: the CPU build fell 11 to 15 minutes behind a 35-minute call with nine channels. On Windows 11 with an RTX 5090 it brought a 20-second window from 15.8 s to 2.5 s. On an RTX 50-series card the first run takes about a minute while the driver compiles its kernels; later runs start at once. Extract the whole archive to a permanent folder, preserving the bundled DLLs. Add the folder containing `whisper-cli.exe` to the user's PATH, open a new PowerShell window, and verify it:

   ```powershell
   whisper-cli --help
   ```

3. Download the models and check the transcription runtime:

   ```powershell
   acta setup
   acta doctor
   ```

Continue with the shared extension, licence, and startup steps below. Report any failed check.

#### If Windows 0.1.20 was installed with workarounds

0.1.21 and later fix what the 0.1.20 test needed workarounds for. Remove them after the upgrade, or they hide a regression:

- Delete `C:\dev\urandom`.
- Delete `date.exe`, `msys-2.0.dll`, `msys-intl-8.dll` and `msys-iconv-2.dll` from the Acta folder.
- Run `acta serve --install` once, so Acta starts at sign-in.

Runs that 0.1.20 created empty on every reconnect stay in `acta ls`; remove them with `acta rm <run>` once the user confirms each one.

### Install the Chrome extension on either platform

Install from the [Chrome Web Store listing](https://chromewebstore.google.com/detail/iidpmegkbdilgbmglnnfealgicfjnglc). Chrome updates Store installations automatically.

If the Store cannot be used, download `acta-extension-0.1.22-unpacked.zip` from the [public release](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.22). Extract it to a permanent folder. Open `chrome://extensions`, enable Developer mode, choose Load unpacked, and select the extracted folder containing `manifest.json`. Keep that folder because Chrome reads it at startup. Chrome may warn about developer mode or disable an unpacked extension after restart.

After installing or updating the extension, open a new Meet call. For an existing call, reload Meet and rejoin when the user can tolerate the interruption. Capture hooks must load before Meet creates its audio decoder.

### Purchase when a licence is missing

If Acta is already installed, use `acta license` and the installed version's help to check its licence. Otherwise ask whether the user already owns one. Do not ask an existing licence holder to buy again, and do not treat a failed licence check as proof that no licence exists.

A valid licence is required to start a new capture. When the user confirms they need one, explain in their language: “To start recording with Acta, you need a licence first. The official purchase link is not available yet; contact the site owner. Once you have a `.licence` file, tell me and we can continue with setup.”

Official Polar checkout links:

- Annual licence: pending — no published Polar checkout URL.
- Lifetime licence: pending — no published Polar checkout URL.

While these links are pending, say that the purchase link is not available yet and direct the user to the site owner. Stop the purchase workflow there. Never send a placeholder URL as a working checkout. Once published, show the options and their current prices and billing terms before directing the user to their chosen checkout.

The user completes payment in Polar. Do not request card details in chat. After they return with a `.licence` file, install it with `acta license add <path>` and verify it with `acta license` before starting a new capture. The same licence also travels as a one-line key beginning `ACTA1-`, and `acta license add <key>` installs from that; the argument is read as a file when a file of that name exists and as a key otherwise. The key is about 250 characters because it carries the signature itself — there is no shorter code, because a short code would have to be looked up on a server and no such server exists. The file is plain text, about 200 bytes, carries an Ed25519 signature over the fields above it, and is a bearer file not tied to a machine. Verification is offline: there is no activation server and nothing is contacted. A message saying payment is complete is not licence verification. If the checkout or activation details are still pending, report that missing step instead of inventing it.

### Add the licence and start Acta

Save the user's `.licence` file and install it with:

```sh
acta license add <path>
acta license
```

Verify that `acta license` names the expected owner and expiry. Licence verification is offline. Then install the background service:

```sh
acta serve --install
```

On Windows this adds a per-user logon entry and starts the daemon; it needs no admin rights. That path has not run on Windows yet. Run `acta doctor` and `acta report` after startup and inspect their results.

For a user-authorized test, open a Google Meet call with the extension loaded and run:

```sh
acta live
```

The live terminal shows the capture. The finished transcript lands at `~/acta/<run>/transcript.md` on macOS or `%USERPROFILE%\acta\<run>\transcript.md` on Windows. `acta ls` lists stored runs.

### Verify setup before calling it complete

On either supported platform, verify diagnostics, the extension connection, and a short user-authorized Google Meet recording. Have another participant speak while the user's microphone is muted. Confirm that audio arrives, then stop the Acta recording and open its finished transcript. Verify named speakers and text from the remote participant. Report the CLI and extension versions, recording location, and unresolved diagnostics. On Windows, request the output of `acta report` and describe only the steps actually verified on that machine.

## Commands

Real Google Meet capture and transcription are verified on macOS Apple Silicon, including remote audio while the user's microphone is muted, and on Windows x64 with 0.1.21. Microsoft Teams and Zoom are unsupported. Confirm syntax with `acta <command> --help` when the installed version differs from this release.

| Need | Command |
| --- | --- |
| Find a recording | `acta ls` (Markdown when piped, `--json` for parsing) |
| Read a transcript | `acta show <run>`, or `acta show <run> --path` for the file path |
| Check the newest run | `acta status`, or `acta status --watch` for JSON lines while it changes |
| Watch a call live | `acta live` |
| Catch spoken requests during a call | `acta assist watch` (see below) |
| Fix a speaker name | `acta name <run> <speaker-id> <name>` |
| Fix misheard names and terms | `acta vocab add <spoken> <canonical>`, then `acta canon <run>` |
| Use the calendar (optional) | Acta asks the `gws` CLI for Google Calendar events, to show the next meeting and record meeting titles and attendee names. Without `gws` Acta records and transcribes the same; nothing needs to be set up |
| Limit language detection | `acta config languages cs,sk`; `auto` allows any. Pin one speaker with `acta config speaker-language <who> <code>` |
| Open the local panel | `acta panel` prints a token-bearing local URL; keep that URL on this computer |
| Check health | `acta doctor`, `acta report`, `acta logs <run>` |
| Send feedback to the author | `acta feedback <message>`; it carries only the message |

## Work with meetings

The transcript is evidence. Speech recognition misses words, so treat names, numbers, and dates as claims to check against the project context and with the user.

### After a meeting: turn it into tasks and do them

1. Run `acta ls` and pick the run with the user. Match the meeting by its time and length.
2. Read the whole transcript with `acta show <run>`.
3. List every request, decision, and open question. For each, record the owner, the deadline, and the quoted line with its timestamp.
4. Map each item to the project: the repository, ticket, document, or person it concerns. Mark the items whose meaning depends on a misheard word.
5. Show the list to the user. Ask which items are yours to carry out.
6. Carry out the approved items in the project with its normal workflow. Report each one as done, blocked, or handed to its owner.

The step is complete when every request in the transcript is accounted for as a task, a decision, someone else's work, or an open question.

### During a meeting: answer spoken requests

`acta assist watch` follows the active run. It prints one line each time someone addresses the assistant by name with a request verb, with the preceding two minutes of transcript as context. `acta config assist-name` and `acta config assist-verbs` show and change the trigger. Use `--json` to parse the lines and `--since-start` to include requests made before the watcher started. Act on each request the same way as a task from the list above.

### Improve the transcript

Name speaker channels with `acta name`. Add recurring names, product names, and jargon with `acta vocab add`, then write a corrected copy with `acta canon <run>`. The original transcript stays unchanged.

### Report a failure

Ask the user for the output of `acta report`. It holds the version, platform, licence state, and counts, and no meeting content. Add `acta logs <run>` for extension problems.

## Privacy

Recordings and transcripts stay on the user's computer. The user decides which transcripts an agent reads and what leaves the machine. Record only meetings the user asks to record. Keep existing runs; delete one with `acta rm` only when the user names it.
