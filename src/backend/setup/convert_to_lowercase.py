import re

file_sql = "usuarios"

# Ruta del archivo original y el archivo de salida
input_file = fr"c:\Users\XT\OneDrive\Documentos\Biz\FEE\_DEV\sys_2026\backend\setup\{file_sql}_0.sql"
output_file = fr"c:\Users\XT\OneDrive\Documentos\Biz\FEE\_DEV\sys_2026\backend\setup\{file_sql}.sql"

# Leer el archivo original
with open(input_file, "r", encoding="utf-8") as file:
    content = file.read()

# Expresión regular para encontrar nombres de tablas y campos
def to_lowercase(match):
    return match.group(0).lower()

# Convertir nombres de tablas y campos a minúsculas
content = re.sub(r"`[A-Za-z0-9_]+`", to_lowercase, content)

# Guardar el archivo modificado
with open(output_file, "w", encoding="utf-8") as file:
    file.write(content)

print(f"Archivo convertido guardado en: {output_file}")