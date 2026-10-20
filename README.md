# Dota 2 Queue-And-Go Reborn by Klain
Dota 2 Queue-And-Go https://github.com/etofok/Dota-2-Queue-and-Go?ysclid=mvgtudct6v551548766 (original code)

Automate matchmaking and match acceptance in Dota 2. The script helps handle match-found prompts and automatically returns to the queue if a match fails to start.

## (!) IMPORTANT: REQUIREMENTS

This script requires **AutoHotkey v1.1**. AutoHotkey v2.0 is not supported.

Download: https://www.autohotkey.com/

## (!) REQUIRED IMAGE SETUP

For automatic match acceptance to work correctly, you must prepare screenshots of the following images:

- `ShareToChat.png`
- `play_button.png`
- `continue_button.png`
- `continue_red.png`

**All images must match your in-game interface and screen resolution.** If you change your resolution or your interface looks different from the examples, capture new screenshots.

### How to capture the images

1. Launch Dota 2 and wait until the required interface element appears.
2. Press `PrintScreen` or use ShareX to take a screenshot.
3. Open the screenshot in Paint and carefully crop it so that only the required interface element remains.
4. Save each image using the exact filename listed above.
5. Place the images in the folder where the script expects to find them.

**Important:** Do not rename the files or alter their contents after setup. The script must be able to find images that match the current in-game interface.

## How to Use

### 1. Configure Dota 2

Open **Settings → Advanced** and enable the following options:

- `Bring Dota to foreground on match found` — brings Dota 2 to the foreground when a match is found.
- `Bring Dota to foreground for ready checks` — brings Dota 2 to the foreground during ready checks.
- `Bring Dota to foreground for pick phase and game start` — brings Dota 2 to the foreground during the pick phase and when the game starts.

### 2. Prepare the images

Make sure all four files — `ShareToChat.png`, `play_button.png`, `continue_button.png`, and `continue_red.png` — have been created and match your in-game interface.

These images are required for the script to recognize the relevant buttons and handle automatic match acceptance.

### 3. Start the script

- Press **`Alt + N`** to activate the script.
- Press **`Alt + M`** to stop or reload the script.

You can change the hotkeys in `hotkeys.ini` using any text editor.

## Optional: Launch Dota 2

You can optionally enable or disable the `Launch Dota 2` option, which allows the script to launch the game.

See `hotkeys.ini` for configuration details.

## How It Works

1. The script locates the matchmaking button and clicks it.
2. Once matchmaking starts, the Dota 2 window is minimized.
3. When a match is found, Dota 2 is brought to the foreground.
4. The script presses `Enter` to confirm readiness if the corresponding action is available.
5. The game window is minimized again while the script waits for the next stage.
6. If another ready-check prompt appears, the script brings the game to the foreground and handles it again.
7. If all players accept the match, the game proceeds to the hero-pick phase.
8. For the next 27 seconds, the script checks for the presence of `ShareToChat.png`.

### What happens next?

- **If `ShareToChat.png` is detected again:** the game has returned to the main lobby. This usually happens when a player fails to connect. The script minimizes the game and continues waiting for another match.
- **If `ShareToChat.png` is not detected:** the script assumes
RU
# Dota 2 Queue-And-Go Reborn by Klain

Автоматизация поиска матча и принятия игры в Dota 2. Скрипт помогает автоматически нажимать кнопки при нахождении матча и повторно вставать в очередь, если игра не состоялась.

## (!) ВАЖНО: ТРЕБОВАНИЯ

Для работы скрипта требуется **AutoHotkey v1.1**. Версия v2.0 не поддерживается.

Скачать: https://www.autohotkey.com/

## (!) ОБЯЗАТЕЛЬНАЯ НАСТРОЙКА ИЗОБРАЖЕНИЙ

Для корректной работы автоматического принятия матча необходимо подготовить скриншоты следующих изображений:

- `ShareToChat.png`
- `play_button.png`
- `continue_button.png`
- `continue_red.png`

**Все изображения должны соответствовать вашему игровому интерфейсу и разрешению экрана.** Если вы изменили разрешение или интерфейс игры отличается от примеров, сделайте новые скриншоты.

### Как сделать скриншоты

1. Запустите Dota 2 и дождитесь появления нужного элемента интерфейса.
2. Нажмите `PrintScreen` или воспользуйтесь ShareX.
3. Откройте скриншот в Paint и аккуратно обрежьте изображение так, чтобы на нём остался только нужный элемент.
4. Сохраните каждый файл под точным именем, указанным выше.
5. Поместите изображения в папку, из которой скрипт их использует.

**Важно:** не переименовывайте файлы и не изменяйте их содержимое после настройки. Скрипт должен находить изображения, соответствующие текущему интерфейсу игры.

## Как пользоваться

### 1. Настройте Dota 2

Откройте «Настройки → Расширенные» и включите следующие параметры:

- `Bring Dota to foreground on match found` — выводить Dota 2 на передний план при нахождении матча.
- `Bring Dota to foreground for ready checks` — выводить Dota 2 на передний план при проверке готовности.
- `Bring Dota to foreground for pick phase and game start` — выводить Dota 2 на передний план во время выбора героев и начала игры.

### 2. Подготовьте изображения

Убедитесь, что все четыре файла — `ShareToChat.png`, `play_button.png`, `continue_button.png` и `continue_red.png` — созданы и соответствуют вашему игровому интерфейсу.

Это необходимо для корректного распознавания кнопок и автоматического принятия матча.

### 3. Запустите скрипт

- Нажмите **`Alt + N`**, чтобы активировать скрипт.
- Нажмите **`Alt + M`**, чтобы остановить или перезагрузить скрипт.

Горячие клавиши можно изменить в файле `hotkeys.ini` с помощью любого текстового редактора.

## Дополнительная опция: запуск Dota 2

При необходимости можно добавить или убрать опцию `Launch Dota 2`, которая позволяет запускать игру через скрипт.

Подробности настройки находятся в файле `hotkeys.ini`.

## Как работает скрипт

1. Скрипт находит кнопку запуска поиска матча и нажимает её.
2. После постановки в очередь окно Dota 2 сворачивается.
3. Когда матч найден, игра автоматически выводится на передний план.
4. Скрипт нажимает `Enter`, чтобы подтвердить готовность, если на экране доступно соответствующее действие.
5. Затем окно игры снова сворачивается, а скрипт ожидает следующего этапа.
6. Если появляется повторное окно подтверждения, скрипт снова выводит игру на передний план и обрабатывает его.
7. Если все игроки приняли матч, начинается переход к выбору героев.
8. В течение следующих 27 секунд скрипт проверяет наличие `ShareToChat.png`.

### Что происходит дальше?

- **Если `ShareToChat.png` снова обнаружено:** игра вернулась в главное лобби. Обычно это происходит, когда кто-то из игроков не смог подключиться к матчу. Скрипт сворачивает игру и продолжает ожидать следующего найденного матча.
- **Если `ShareToChat.png` не обнаружено:** предполагается, что игроки успешно подключились и игра перешла к следующему этапу. Скрипт автоматически завершает работу по истечении 27 секунд, если не был остановлен вручную.

## Горячие клавиши

| Клавиши | Действие |
|---|---|
| `Alt + N` | Активировать скрипт |
| `Alt + M` | Остановить или перезагрузить скрипт |

**Примечание:** результат распознавания изображений зависит от разрешения экрана, масштаба интерфейса и актуального внешнего вида Dota 2. При изменении этих параметров может потребоваться сделать новые скриншоты.
