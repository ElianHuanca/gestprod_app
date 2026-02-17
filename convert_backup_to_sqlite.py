# -*- coding: utf-8 -*-
"""Convierte backup MySQL a SQLite con IDs en formato UUID v4."""

import re
import uuid

# Generar UUIDs deterministas (formato v4: 8-4-4-4-12, con 4 y 8 en posiciones correctas)
def make_uuid(prefix: str, n: int) -> str:
    """Genera un UUID determinista con formato v4 para (prefix, n)."""
    name = f"{prefix}_{n}"
    # uuid5 es determinista; produce formato estándar 8-4-4-4-12
    u = uuid.uuid5(uuid.NAMESPACE_DNS, name)
    s = str(u)
    # Ajustar a formato v4: posición 14 = '4', posición 19 = '8'|'9'|'a'|'b'
    return s[0:14] + '4' + s[15:19] + '8' + s[20:]

# Mapeos de id numérico -> UUID por tabla
def build_mappings():
    maps = {}
    # categorias: 1, 2
    maps['categorias'] = {i: make_uuid('categoria', i) for i in [1, 2]}
    # colores: 1-32, 34-41
    maps['colores'] = {i: make_uuid('color', i) for i in list(range(1, 33)) + list(range(34, 42))}
    # compras: 1, 9, 10, ..., 25
    compra_ids = [1, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
    maps['compras'] = {i: make_uuid('compra', i) for i in compra_ids}
    # productos: 1-15
    maps['productos'] = {i: make_uuid('producto', i) for i in range(1, 16)}
    # sucursales: 1, 2
    maps['sucursales'] = {i: make_uuid('sucursal', i) for i in [1, 2]}
    # tipos_gastos: 1-6
    maps['tipos_gastos'] = {i: make_uuid('tipo_gasto', i) for i in range(1, 7)}
    # ventas: 1, 3, 4, ..., 17
    venta_ids = [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
    maps['ventas'] = {i: make_uuid('venta', i) for i in venta_ids}
    # venta_producto: id 1-104
    maps['venta_producto'] = {i: make_uuid('venta_producto', i) for i in range(1, 105)}
    return maps

M = build_mappings()

def replace_ids_in_tuple(text, table, columns):
    """Reemplaza IDs numéricos por UUID en una tupla (val1, val2, ...) según tabla y columnas."""
    def repl(m):
        inner = m.group(1)
        parts = []
        for i, col in enumerate(columns):
            # Encontrar el i-ésimo valor (número o string)
            # Valores pueden ser: número, 'string', NULL
            pattern = r"(\d+)|'([^']*)'|NULL"
            rest = inner
            for j in range(len(columns)):
                if j == i:
                    subm = re.match(r"\s*(\d+)\s*,|\s*(\d+)\s*$|\s*'([^']*)'\s*,|\s*'([^']*)'\s*$|\s*NULL\s*,|\s*NULL\s*$", rest)
                    if subm:
                        if col in M and subm.group(1):
                            num = int(subm.group(1))
                            if num in M[col]:
                                parts.append("'" + M[col][num] + "'")
                            else:
                                parts.append(subm.group(0).strip().rstrip(','))
                        else:
                            parts.append(subm.group(0).strip().rstrip(','))
                    break
                # Consumir un valor
                if rest.strip().startswith("'"):
                    q = rest.index("'", 1) + 1
                    if q < len(rest) and rest[q:].strip().startswith(','):
                        rest = rest[q:].strip()[1:].strip()
                    else:
                        rest = rest[q:].strip()
                elif rest.strip().upper().startswith('NULL'):
                    rest = rest.strip()[4:].strip().lstrip(',').strip()
                else:
                    rest = re.sub(r'^\s*\d+(\.\d+)?\s*,?\s*', '', rest, count=1)
        return '(' + inner + ')'
    return text

def convert_value_tuple(line, table, col_order):
    """Convierte una línea de valores (n1, n2, 'x', ...) reemplazando IDs por UUID."""
    result = []
    # Encontrar cada tupla en la línea (puede haber varias separadas por coma)
    def repl_tuple(m):
        content = m.group(1)
        # Dividir por comas respetando strings y paréntesis
        values = []
        current = []
        depth = 0
        in_str = False
        quote = None
        i = 0
        while i < len(content):
            c = content[i]
            if in_str:
                if c == quote and (i+1 >= len(content) or content[i+1] != quote):
                    in_str = False
                current.append(c)
                i += 1
                continue
            if c in ("'", '"'):
                in_str = True
                quote = c
                current.append(c)
                i += 1
                continue
            if c == '(':
                depth += 1
                current.append(c)
                i += 1
                continue
            if c == ')':
                depth -= 1
                current.append(c)
                i += 1
                continue
            if depth == 0 and c == ',':
                values.append(''.join(current).strip())
                current = []
                i += 1
                continue
            current.append(c)
            i += 1
        if current:
            values.append(''.join(current).strip())
        # values = lista de valores de una fila
        if len(values) != len(col_order):
            return m.group(0)
        out = []
        for idx, col in enumerate(col_order):
            val = values[idx].strip()
            if col in M and re.match(r'^\d+$', val):
                n = int(val)
                if n in M[col]:
                    out.append("'" + M[col][n] + "'")
                else:
                    out.append(val)
            else:
                out.append(val)
        return '(' + ', '.join(out) + ')'
    # Una línea puede ser: (a,b,c), (d,e,f), ...
    line_out = re.sub(r'\(([^()]*(?:\([^()]*\)[^()]*)*)\)', lambda m: repl_tuple(m) if m.group(1) else m.group(0), line)
    return line_out

def simple_replace_ids(line, table, col_indices):
    """Reemplaza los números en posiciones col_indices (0-based) por UUID para esa tabla."""
    # Buscar tuplas (..., ..., ...)
    def repl(m):
        inner = m.group(1)
        parts = re.split(r",\s*(?=(?:[^']*'[^']*')*[^']*$)", inner)  # split por coma fuera de comillas
        if len(parts) != len(col_indices):
            return m.group(0)
        for idx in col_indices:
            if idx < len(parts):
                p = parts[idx].strip()
                if re.match(r'^\d+$', p) and table in M:
                    n = int(p)
                    if n in M[table]:
                        parts[idx] = " '" + M[table][n] + "'"
        return '(' + ','.join(parts) + ')'
    return re.sub(r'\(([^)]+)\)', repl, line)

def main():
    with open('backup.sql', 'r', encoding='utf-8') as f:
        content = f.read()

    out = []
    out.append("-- SQLite backup (convertido desde MySQL)")
    out.append("-- IDs en formato UUID v4 (compatible con uuid.v4())")
    out.append("")
    out.append("PRAGMA foreign_keys = OFF;")
    out.append("")
    
    # Eliminar bloques MySQL
    content = re.sub(r'SET SQL_MODE = .*?;', '', content)
    content = re.sub(r'START TRANSACTION;', '', content)
    content = re.sub(r'SET time_zone = .*?;', '', content)
    content = re.sub(r'/\*!40101.*?\*/;', '', content, flags=re.DOTALL)
    content = re.sub(r'COMMIT;', '', content)
    content = re.sub(r'/\*!40101 SET.*?\*/', '', content, flags=re.DOTALL)

    # Procesar por bloques: CREATE TABLE e INSERT
    blocks = re.split(r'(-- -+\n\n--\s*\n--[^\n]*\n--\s*\n)', content)
    
    for block in blocks:
        if 'CREATE TABLE' in block:
            # Convertir CREATE a SQLite
            table_match = re.search(r'CREATE TABLE `(\w+)`\s*\((.*?)\)\s*ENGINE', block, re.DOTALL)
            if table_match:
                table_name = table_match.group(1)
                defs = table_match.group(2)
                # Quitar coma final antes del )
                defs = re.sub(r',\s*\)', ')', defs)
                # Convertir tipos MySQL -> SQLite
                defs = re.sub(r'`(\w+)`\s+tinyint\([^)]+\)\s+UNSIGNED\s+NOT NULL', r'"\1" TEXT', defs)
                defs = re.sub(r'`(\w+)`\s+tinyint\([^)]+\)\s+UNSIGNED', r'"\1" TEXT', defs)
                defs = re.sub(r'`(\w+)`\s+tinyint\([^)]+\)', r'"\1" INTEGER', defs)
                defs = re.sub(r'`(\w+)`\s+int\([^)]+\)\s+UNSIGNED\s+NOT NULL', r'"\1" TEXT', defs)
                defs = re.sub(r'`(\w+)`\s+int\([^)]+\)\s+UNSIGNED', r'"\1" TEXT', defs)
                defs = re.sub(r'`(\w+)`\s+int\([^)]+\)', r'"\1" INTEGER', defs)
                defs = re.sub(r'`(\w+)`\s+decimal\([^)]+\)', r'"\1" REAL', defs)
                defs = re.sub(r'`(\w+)`\s+varchar\([^)]+\)', r'"\1" TEXT', defs)
                defs = re.sub(r'`(\w+)`\s+date\s+NOT NULL DEFAULT curdate\(\)', r'"\1" TEXT DEFAULT (date(\'now\'))', defs)
                defs = defs.replace(r"date(\'now\')", "date('now')")  # SQLite: sin backslash
                defs = re.sub(r',\s*$', '', defs)  # quitar coma final
                defs = re.sub(r'`(\w+)`\s+date', r'"\1" TEXT', defs)
                defs = re.sub(r'DEFAULT TRUE', 'DEFAULT 1', defs, flags=re.I)
                defs = re.sub(r'UNSIGNED', '', defs)
                out.append(f'CREATE TABLE IF NOT EXISTS "{table_name}" (\n  ' + defs.strip().replace(',', ',\n  ') + '\n);')
                out.append("")
            # No continue: el mismo bloque puede tener INSERT

        if 'INSERT INTO' in block:
            # Procesar INSERT: reemplazar IDs según tabla
            insert_match = re.search(r"INSERT INTO `(\w+)`\s*\(([^)]+)\)\s*VALUES\s*(.+)", block, re.DOTALL)
            if insert_match:
                table_name = insert_match.group(1)
                cols = [c.strip().strip('`') for c in insert_match.group(2).split(',')]
                values_part = insert_match.group(3).strip()
                # Quitar ; final
                values_part = values_part.rstrip(';').strip()
                # Mapear nombre columna -> tabla para FK
                col_to_entity = {}
                if table_name == 'categorias':
                    col_to_entity = {'id': 'categorias'}
                elif table_name == 'colores':
                    col_to_entity = {'id': 'colores'}
                elif table_name == 'compras':
                    col_to_entity = {'id': 'compras', 'sucursal_id': 'sucursales'}
                elif table_name == 'compra_producto':
                    col_to_entity = {'compra_id': 'compras', 'producto_id': 'productos', 'color_id': 'colores'}
                elif table_name == 'gastos':
                    col_to_entity = {'tipo_gasto_id': 'tipos_gastos', 'compra_id': 'compras'}
                elif table_name == 'inventario':
                    col_to_entity = {'sucursal_id': 'sucursales', 'producto_id': 'productos', 'color_id': 'colores'}
                elif table_name == 'productos':
                    col_to_entity = {'id': 'productos', 'categoria_id': 'categorias'}
                elif table_name == 'sucursales':
                    col_to_entity = {'id': 'sucursales'}
                elif table_name == 'tipos_gastos':
                    col_to_entity = {'id': 'tipos_gastos'}
                elif table_name == 'ventas':
                    col_to_entity = {'id': 'ventas', 'sucursal_id': 'sucursales'}
                elif table_name == 'venta_producto':
                    col_to_entity = {'id': 'venta_producto', 'venta_id': 'ventas', 'producto_id': 'productos', 'color_id': 'colores'}

                # Reemplazar cada tupla de valores
                lines = values_part.split('\n')
                new_lines = []
                for line in lines:
                    line = line.strip()
                    if not line:
                        continue
                    # En esta línea hay una o más tuplas (v1, v2, ...)
                    def replace_tuple(m):
                        t = m.group(1)
                        # Split valores (respetando strings entre comillas)
                        vals = []
                        cur = []
                        inq = False
                        qchar = None
                        i = 0
                        while i < len(t):
                            c = t[i]
                            if inq:
                                if c == qchar:
                                    inq = False
                                cur.append(c)
                                i += 1
                                continue
                            if c in ("'", '"'):
                                inq = True
                                qchar = c
                                cur.append(c)
                                i += 1
                                continue
                            if c == ',' and not inq:
                                vals.append(''.join(cur).strip())
                                cur = []
                                i += 1
                                continue
                            cur.append(c)
                            i += 1
                        if cur:
                            vals.append(''.join(cur).strip())
                        if len(vals) != len(cols):
                            return m.group(0)
                        out_vals = []
                        for j, col in enumerate(cols):
                            entity = col_to_entity.get(col)
                            v = vals[j]
                            if entity and entity in M and re.match(r'^\d+$', v):
                                n = int(v)
                                if n in M[entity]:
                                    out_vals.append("'" + M[entity][n] + "'")
                                else:
                                    out_vals.append(v)
                            else:
                                out_vals.append(v)
                        return '(' + ', '.join(out_vals) + ')'
                    new_line = re.sub(r'\(([^()]*)\)', replace_tuple, line)
                    if new_line.endswith(';'):
                        new_line = new_line[:-1]
                    if new_line.rstrip().endswith(','):
                        new_line = new_line.rstrip()[:-1]  # quitar coma final para no duplicar al hacer join
                    new_lines.append(new_line)
                out.append("INSERT INTO \"{}\" ({}) VALUES\n{};".format(
                    table_name,
                    ', '.join('"'+c+'"' for c in cols),
                    ',\n'.join(new_lines)
                ))
                out.append("")
            continue

        # Comentarios y ALTER TABLE: omitir ALTER (índices y FK se pueden recrear en SQLite distinto)
        if 'ALTER TABLE' in block or 'AUTO_INCREMENT' in block or 'ADD CONSTRAINT' in block or 'MODIFY' in block or 'ADD PRIMARY' in block or 'ADD KEY' in block:
            continue
        if block.strip().startswith('--'):
            out.append(block.strip())
            out.append("")

    out.append("PRAGMA foreign_keys = ON;")
    
    with open('backup_sqlite.sql', 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    print("Generado backup_sqlite.sql")

if __name__ == '__main__':
    main()
