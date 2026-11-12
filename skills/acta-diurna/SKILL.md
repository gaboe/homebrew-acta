---
name: acta-diurna
description: Install and set up the Acta Diurna desktop app or CLI on Mac and Windows. Use for dictation setup and failures, licences, local Google Meet recording, reading transcripts, turning meetings into tasks, or following live requests during a call.
metadata:
  status: macos-verified-windows-0.1.21-verified
---

# Acta Diurna

Acta Diurna is for Mac and Windows. Meetings are transcribed on the user's computer into Markdown with speaker names and timestamps. The Chrome extension captures Google Meet audio. The daemon receives it and runs transcription. The `acta` CLI gives agents access to diagnostics and transcripts. The desktop app provides a meeting interface and dictation into other apps. Dictation uses local Whisper or ElevenLabs. Linux is unsupported. Check the platform and build limits below before installing.

For desktop installation or dictation, start with **Desktop app and dictation**. For CLI installation or a missing licence, use **Setup**. For transcript tasks, use **Work with meetings**.

## Desktop app and dictation

### Get and install the desktop app

Inspect the OS, CPU architecture, existing Acta installation, and app version first. Mac desktop packaging targets Apple Silicon and macOS 13 or later. Windows x64 has a published CLI, daemon, and extension path below. The Windows x64 Scoop package also installs an unsigned desktop app with a Start menu entry. Do not describe Windows desktop or dictation as verified. Intel Macs, Windows ARM, and Linux have no supported installation path here.

The [public v0.1.33 release](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.33) includes [acta-desktop-0.1.33-arm64-unsigned.zip](https://github.com/gaboe/homebrew-acta/releases/download/v0.1.33/acta-desktop-0.1.33-arm64-unsigned.zip) and its checksum sidecar. Asset availability was checked on 2026-11-09. This archive has an ad-hoc signature. It has no Developer ID signature and is not notarized. Availability is not proof of first-run or dictation success. Check the current release assets before offering a newer build. If an asset is absent, report it as unavailable.

1. Download the ZIP and its matching checksum sidecar from that release. Calculate its SHA-256 with `shasum -a 256 <zip>` and compare it with the sidecar and the release asset digest. In a source checkout, also compare with `packaging/desktop-release.json`. Stop if they differ.
2. Extract the ZIP. Move `Acta.app` to Applications or the user-owned `~/Applications` folder. Keep an existing app until the replacement is verified.
3. Open Acta. If macOS blocks this unsigned build, explain its signing state and let the user decide whether to allow it in System Settings > Privacy & Security. Keep Gatekeeper enabled. Report a blocked launch as incomplete setup.
4. Use the bundled CLI at `<installed Acta.app>/Contents/MacOS/acta` for the checks below when `acta` is not on PATH. Check its version before using a separate Homebrew CLI. Installing the app does not add a shell command to PATH.

For an authorized source build on an Apple Silicon Mac, the repository also has `bash desktop/install.sh`. It builds and installs `~/Applications/Acta.app`, replacing that app and stopping its running process. It uses a local signing certificate when available, otherwise ad-hoc signing. It is not a public binary installer or proof of notarization. Prefer the published archive for normal installation.

The app bundles the CLI and Whisper binaries. Its meeting views use the local daemon. Follow the shared licence and background-service steps below when needed, using the matching CLI. Homebrew alone installs the CLI, not the desktop app. The Chrome extension is needed for Google Meet capture. Dictation and in-person microphone recording do not need that extension.

### First-run setup

These steps describe current source capabilities. Confirm that each control exists in the installed build. A shared version number does not prove that an older archive includes later source changes. Report missing controls instead of claiming that setup succeeded.

1. Open Settings. Select the interface language. Set the dictation language separately to Slovak, Czech, English, or automatic detection. Meeting language uses `acta config languages` below.
2. For dictation or in-person recording, allow Acta microphone access. For the dictation shortcut and text insertion, allow Accessibility in System Settings > Privacy & Security. Follow the app permission rows and confirm their resulting state. This desktop permission flow requests Microphone and Accessibility. It does not request Screen Recording or system-audio access. For Meet capture, follow Chrome and the extension prompts for the installed version. Report any extra permission request by its actual name and purpose.
3. For Meet, open the Chrome extension section and follow **Install the Chrome extension on either platform** below. Keep extension connection checks separate from app launch checks.
4. Open the licence section. Add the user's `.licence` file, or use the CLI licence procedure below. Verify owner and expiry. If purchase details are missing, follow **Purchase when a licence is missing**. Recording can precede a licence; meeting transcription requires a valid licence.
5. Open dictation settings. Set the shortcut and enable push to talk if wanted. The source default is Right Option + Space. With push to talk enabled, hold the shortcut to dictate and release it to insert text. Another key cancels dictation. Check for shortcut conflicts before saving.
6. Choose local Whisper to keep dictation inference on the computer. Check model readiness and report missing runtime or model steps. For ElevenLabs Scribe v2 realtime, explain that dictation audio leaves the computer for ElevenLabs. Let the user enter their own API key directly in Settings and select it. Keep keys out of chat, logs, and reports. Check the installed build's key-storage text. Older builds use macOS Keychain; current source migrates those keys to a file readable only by that macOS user. Do not claim Keychain storage for every build.
7. Set the action after dictation and clipboard retention. Review Dictations history and the keep-dictation-audio choice with the user. Dictionary word pairs correct dictated text. Disabling audio retention does not delete existing audio. Keep existing history and audio unless the user asks to delete them.

### Verify without recording the user

Open the app and check its version, daemon connection, licence state, permission rows, saved shortcut, engine, and language. Run `acta report --json` with the matching CLI. Report failed or unknown checks. Inspect the extension connection only if Chrome is available. Do not start a meeting, press the dictation shortcut, request a live microphone sample, or open stored recordings for this check.

Call this setup checked without capture. State that microphone capture, dictation insertion, and meeting transcription remain unverified. Use **Verify setup before calling it complete** only when the user authorizes a recording test. A dictation test also needs the user's authorization and a text field they choose.

For dictation failure, run `acta report --json` first and `acta logs` second. Inspect desktop and dictation event codes, engine, permissions, shortcut state, and coverage. Use `acta doctor` only for a current inference failure. If an older build lacks dictation diagnostics, report that gap. A missing event means unknown. Do not read Dictations history or retained audio unless the user authorizes it. Preview diagnostics before sharing them. Do not send a report through `acta feedback` without an explicit request.

## Setup

macOS on Apple Silicon is verified. Windows x64 0.1.21 was verified on Windows 11 on 2026-10-12: install without admin rights, background service, Meet capture and the final transcript, with no workarounds. A retest of 0.1.22 on 2026-10-13 confirmed its fixes and found the archive missing the user's own microphone; 0.1.23 fixes that; 0.1.24 keeps the daemon answering while it finishes a long meeting, 0.1.25 stops it cleanly within launchd's limit, 0.1.26 finishes on its next start a transcript it was stopped in the middle of, 0.1.27 finishes the final transcript that 0.1.26 stopped at a timestamp check, and 0.1.31 adds `acta new` for in-person meetings from the Mac microphone and makes `acta prune` remove the audio of transcribed meetings. None of these has run on Windows yet. Intel Macs and Windows ARM are unsupported. Both platforms use Google Meet in Chrome and the published Chrome extension.

### Installation gate

Inspect the operating system, CPU architecture, and whether `acta` is already installed. Report those findings. On macOS Apple Silicon, follow the macOS procedure. On Windows x64, say that 0.1.21 was verified there and 0.1.33 only in a Windows 11 VM, and follow the Windows procedure. For an unsupported platform, report the missing build and stop. Use the published packages and instructions below.

| Distribution detail | Current value |
| --- | --- |
| Public Homebrew tap / release | [`gaboe/acta`](https://github.com/gaboe/homebrew-acta), public release [`v0.1.33`](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.33). arm64 artifact `acta-0.1.33-arm64.tar.gz`, SHA-256 `9a0b73510d8b34a84024ad2580e5c1fbe0fea8439bd1f9e5bce704dbe06f6d21`; Windows x64 artifact `acta-0.1.33-x64.zip`, SHA-256 `72d9fdbf4f48a2f01c490354b3ed75dd6f4560d351f442c6e50af5d492761960`. Built locally on 2026-11-12 and published from that build. |
| macOS Apple Silicon installer | Homebrew tap `gaboe/acta`, formula `acta`; use the verified procedure below. For the desktop ZIP, use **Desktop app and dictation**. |
| macOS installation procedure | Verified today: `brew trust gaboe/acta`, `brew tap gaboe/acta`, `brew install acta`, `acta setup`; `brew trust` must come first. |
| Windows x64 installer | Published. 0.1.21 was verified on Windows 11 and 0.1.22 retested there; 0.1.33 was installed, updated and tested in a Windows 11 VM, not yet on a Windows PC. `acta-0.1.33-x64.zip` is on the same release as the macOS tarball, built locally and confirmed to be a PE32+ console executable. The Scoop manifest is at `https://raw.githubusercontent.com/gaboe/homebrew-acta/main/scoop/acta.json`. Only x64; there is no Windows-on-ARM build. |
| Windows installation procedure | Follow the Windows x64 procedure below. Scoop installs ffmpeg; install whisper-cli separately. `acta serve --install` adds a per-user logon entry without admin rights. |
| Chrome extension distribution | [Chrome Web Store listing](https://chromewebstore.google.com/detail/iidpmegkbdilgbmglnnfealgicfjnglc), unlisted and reachable by this link. Extension 0.1.23 records the user's own microphone in `recording.wav` and keeps the archive's last chunk; with 0.1.22 and earlier the archive holds only the other participants. It was submitted to the Store on 2026-10-13 and is in review, so the listing may still serve an older version. The 0.1.33 release carries the same extension code as an unpacked ZIP, to load now. Store and unpacked installations share the same extension id, so use only one at a time. |

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

   Without Scoop, install by hand. Scoop is not on Windows by default, and its installer pipes a downloaded script into PowerShell, which many agents refuse to run. Download `acta-0.1.33-x64.zip` from the [public release](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.33) and check its SHA-256 against the distribution table. Extract it to `%LOCALAPPDATA%\Programs\acta` and add that folder to the user's PATH. Install ffmpeg with `winget install Gyan.FFmpeg` if `ffmpeg -version` fails. Open a new PowerShell window and run the two version checks above.

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

If the Store cannot be used, download `acta-extension-0.1.33-unpacked.zip` from the [public release](https://github.com/gaboe/homebrew-acta/releases/tag/v0.1.33). Extract it to a permanent folder. Open `chrome://extensions`, enable Developer mode, choose Load unpacked, and select the extracted folder containing `manifest.json`. Keep that folder because Chrome reads it at startup. Chrome may warn about developer mode or disable an unpacked extension after restart.

After installing or updating the extension, open a new Meet call. For an existing call, reload Meet and rejoin when the user can tolerate the interruption. Capture hooks must load before Meet creates its audio decoder.

### Purchase when a licence is missing

If Acta is already installed, use `acta license` and the installed version's help to check its licence. Otherwise ask whether the user already owns one. Do not ask an existing licence holder to buy again, and do not treat a failed licence check as proof that no licence exists.

Recording does not need a licence. Acta saves audio and waits to transcribe until a valid licence is installed. When the user confirms they need a licence, explain in their language: “You can record now and add a licence later. Acta needs a valid licence to transcribe the recording. The official purchase link is not available yet; contact the site owner. Once you have a `.licence` file, tell me and we can continue with setup.”

Official Polar checkout links:

- Annual licence: pending — no published Polar checkout URL.
- Lifetime licence: pending — no published Polar checkout URL.

While these links are pending, say that the purchase link is not available yet and direct the user to the site owner. Stop the purchase workflow there. Never send a placeholder URL as a working checkout. Once published, show the options and their current prices and billing terms before directing the user to their chosen checkout.

The user completes payment in Polar. Do not request card details in chat. After they return with a `.licence` file, install it with `acta license add <path>` and verify it with `acta license` before transcription. The user can record before installing it. The same licence also travels as a one-line key beginning `ACTA1-`, and `acta license add <key>` installs from that; the argument is read as a file when a file of that name exists and as a key otherwise. The key is about 250 characters because it carries the signature itself — there is no shorter code, because a short code would have to be looked up on a server and no such server exists. The file is plain text, about 200 bytes, carries an Ed25519 signature over the fields above it, and is a bearer file not tied to a machine. Verification is offline: there is no activation server and nothing is contacted. A message saying payment is complete is not licence verification. If the checkout or activation details are still pending, report that missing step instead of inventing it.

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

On Windows this adds a per-user logon entry and starts the daemon; it needs no admin rights. The 0.1.33 startup path ran in a Windows 11 VM, not yet on a Windows PC. Run `acta doctor` and `acta report` after startup and inspect their results.

To update a Scoop installation of 0.1.33 or later, run `acta update`. Acta stops, Scoop installs the new version, and Acta starts again. Run no other acta command until `Get-Content "$env:TEMP\acta-update.log" -Tail 1` starts with `acta update: done`. Do not run `scoop update acta` while Acta runs, because Scoop refuses. To update 0.1.32 or earlier, stop Acta first:

```powershell
acta serve --uninstall
Get-Process | Where-Object { $_.Path -like "$env:USERPROFILE\scoop\apps\acta\*" } | Stop-Process -Force
scoop update acta
acta serve --install
```

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
| Record an in-person meeting on macOS | `acta new [--title <text>]`, when installed help lists `new`. Enter or Ctrl+C stops capture and transcribes. A further Ctrl+C pauses transcription; `acta transcribe <run>` resumes. One speaker channel, no diarization. Windows is not supported yet. |
| Watch a call live | `acta live` |
| Catch spoken requests during a call | `acta assist watch` (see below) |
| Fix a speaker name | `acta name <run> <speaker-id> <name>` |
| Fix misheard names and terms | `acta vocab add <spoken> <canonical>`, then `acta canon <run>` |
| Use the calendar (optional) | Acta reads Google Calendar events to show the next meeting and record meeting titles and attendee names. Connect it in the desktop app under Settings > Calendar > Connect Google, or let Acta ask the `gws` CLI. On macOS it can also read macOS Calendar. Without a calendar Acta records and transcribes the same; nothing needs to be set up |
| Limit language detection | `acta config languages cs,sk`; `auto` allows any. Pin one speaker with `acta config speaker-language <who> <code>` |
| Open the local panel | `acta panel` prints a token-bearing local URL; keep that URL on this computer |
| Diagnose a failure | `acta report --json`, then `acta logs [run]`; use `acta doctor` only for an active inference problem |
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

### Diagnose a failed recording

For a recording or dictation failure, run `acta report --json` first. It reads a bounded local
report without opening a recording or transcript. Run `acta logs [run]` second to inspect typed
events. Omit `run` when the failure happened before Acta created a recording. Use `acta doctor` only
when inference is failing now.

With a run selected, `history.events` contains only events for that recording.
`global_context.events` holds events without a run identity and keeps the
`unavailable_global_context_only` label. These events are context, not evidence for that run.
The process keeps up to 256 random recording identities in memory. The diagnostics worker saves each to `diagnostic-id.json`.
Identities created before diagnostics starts stay pending until startup queues them.
After that bound, new recordings use their numeric directory identity without an identity file.
A nonstandard directory beyond the bound remains unattributed.
Recording and startup continue while diagnostic writes are pending. Treat queue acceptance as unconfirmed persistence.
Legacy `meet-<number>` directories use their generated number as a fallback.
Older events and other run names without a saved identity remain unattributed. Extension batches remain global
because a delivered batch can include events from before the current recording.
Daemon and desktop restart aggregates expose `starts` and `restarts` with the newest startup
and failure facts. Earlier repeated process events can be folded into that aggregate.
Each failure still expires after seven days. If temporary replacement space is unavailable,
aggregation preserves existing evidence and records a diagnostic write error in the live loss counters.

Use event codes and coverage to state what the evidence shows. Treat missing events as unknown.
The CLI cannot read Chrome history while the extension is disconnected. A missing clean-exit event
does not prove a crash, an out-of-memory kill, or an operating-system cause. Diagnostics stay on
the machine unless the user chooses to share the report. `acta feedback` is unchanged.

## Privacy

Meeting recordings and transcripts stay on the user's computer. Local dictation stays on the computer. ElevenLabs dictation sends audio to ElevenLabs with the user's API key. The user decides which transcripts an agent reads and what leaves the machine. Record only meetings the user asks to record. Keep existing runs; delete one with `acta rm` only when the user names it.
