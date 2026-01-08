

# Speech Dispatcher + Piper TTS (Manjaro, ArchLinux)

Настройка системного TTS через **speech-dispatcher** и **Piper TTS** с несколькими языками (ru, de) и интеграцией с браузерами (Firefox).

## Пакеты

Установить базовые пакеты:

```bash
# middleware
sudo pacman -S speech-dispatcher

# Piper (через AUR)
yay -S piper-tts-bin

# голоса Piper (через AUR; при необходимости патчить PKGBUILD, см. ниже)
yay -S piper-voices-ru-ru piper-voices-de-de
```

### Фикс PKGBUILD для piper-voices-\*

Если при сборке `piper-voices-ru-ru`/`piper-voices-de-de` вылезает ошибка `git lfs install`, правка такая:

```bash
git clone https://aur.archlinux.org/piper-voices-ru-ru.git
cd piper-voices-ru-ru
sed -i 's/git lfs install/git lfs install --local/' PKGBUILD
makepkg -si
```

Аналогично для других пакетов `piper-voices-*`.

## Структура файлов

В этом репозитории конфиги хранятся в «домашнем» виде:

- `speech-dispatcher/speechd.conf` → копируется в `/etc/speech-dispatcher/speechd.conf`  
- `speech-dispatcher/modules/piper-generic.conf` → копируется в `/etc/speech-dispatcher/modules/piper-generic.conf`

Командой:

```bash
sudo mkdir -p /etc/speech-dispatcher/modules

sudo cp speech-dispatcher/speechd.conf \
        /etc/speech-dispatcher/speechd.conf

sudo cp speech-dispatcher/modules/piper-generic.conf \
        /etc/speech-dispatcher/modules/piper-generic.conf
```

Дальше **все приложения** (включая Firefox) будут использовать эти системные файлы.

## Конфиг speech-dispatcher (system-wide)

Файл: `/etc/speech-dispatcher/speechd.conf`.

Ключевые фрагменты:

```conf
# Выбор аудио (по умолчанию pulse/pipewire)
AudioOutputMethod "pulse"

# Модуль Piper (generic)
AddModule "piper-generic" "sd_generic" "piper-generic.conf"

# Использовать Piper по умолчанию
DefaultModule "piper-generic"

# Языки, которые должны идти в Piper
LanguageDefaultModule "ru" "piper-generic"
LanguageDefaultModule "de" "piper-generic"
# при необходимости:
# LanguageDefaultModule "en" "piper-generic"
```

Остальные `AddModule`/`LanguageDefaultModule` для `de`/`en` (espeak, festival и т.п.) желательно закомментировать, чтобы не было конфликтов голосов.

## Модуль Piper (piper-generic.conf)

Файл: `/etc/speech-dispatcher/modules/piper-generic.conf`.

```conf
# Универсальный запуск Piper, выбор модели через $VOICE
GenericExecuteSynth "echo \"$DATA\" | piper-tts -q --model \"/usr/share/piper-voices/$VOICE\" -f - | aplay"

# Русский (Irina)
GenericLanguage "ru" "ru_RU" "utf-8"
AddVoice "ru" "FEMALE1" "ru/ru_RU/irina/medium/ru_RU-irina-medium.onnx"

# Немецкий (Kerstin)
GenericLanguage "de" "de_DE" "utf-8"
AddVoice "de" "FEMALE1" "de/de_DE/kerstin/low/de_DE-kerstin-low.onnx"

# Голос по умолчанию (строка == третьему аргументу AddVoice)
DefaultVoice "ru/ru_RU/irina/medium/ru_RU-irina-medium.onnx"
```

Важно:

- `AddVoice` третий аргумент — **относительный путь** от `/usr/share/piper-voices`.
- `DefaultVoice` должен совпадать с ним **символ в символ**, иначе дефолтный голос не сработает.
- Пути нужно подправить под конкретные установленные Piper‑voices (см. `ls /usr/share/piper-voices/ru` / `de`).

## Перезапуск и тест

Перезапуск службы:

```bash
systemctl --user restart speech-dispatcher
systemctl --user status speech-dispatcher --no-pager
```

Проверка CLI:

```bash
# список голосов
spd-say -L

# русский (Irina)
spd-say -l ru -t female1 "Привет, это Irina."

# немецкий (Kerstin)
spd-say -l de -t female1 "Hallo, ich bin Kerstin."
```

Если говорит как ожидается — конфиг Piper + speech-dispatcher рабочий.

## Firefox и браузеры

Firefox использует тот же speech-dispatcher, поэтому после правки `/etc/speech-dispatcher/...`:

1. Полностью закрыть Firefox.  
2. Запустить, в Web Console:

   ```js
   speechSynthesis.getVoices()
   ```

3. В списке должны появиться Piper‑голоса с `voiceURI` на Irina/Kerstin.

Опционально можно явно привязать голоса к языкам в Reader View:

- `about:config` → `narrate.voice`  
- пример значения:

```json
{"default":"automatic",
 "de":"urn:moz-tts:speechd:de/de_DE/kerstin/low/de_DE-kerstin-low?de",
 "ru":"urn:moz-tts:speechd:ru/ru_RU/irina/medium/ru_RU-irina-medium?ru"}
```

Так Firefox будет читать немецкие и русские страницы именно голосами Piper, заданными в конфиге.

***

Если хочешь, можно дополнительно добавить в README краткий раздел «Troubleshooting» (как проверять `systemctl --user status speech-dispatcher`, `speechd.log`, и что делать, если появляются старые голоса типа Thorsten/Ryan).

