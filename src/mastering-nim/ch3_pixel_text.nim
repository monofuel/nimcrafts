import pixels

# `yum install mozilla-fira-sans-fonts`

# issue on Fedora, TTF folder does not exist but pixel assumes it does

# const location = r"/usr/share/fonts/TTF/"


drawText(30, 40, "Welcome to Nim!", 10, Yellow)

# $ to convert to string
# & to concatenate
drawText(30, 60, "number: " & $10, 10, Yellow)
