import mysql.connector
import re

# Datos de conexión
config = {
    'host': 'localhost',
    'database': 'sistema_ventas_mas',
    'user': 'root',
    'password': '1234'
}

def conectar():
    try:
        return mysql.connector.connect(**config)
    except Exception as e:
        print(f"Error de conexión: {e}")
        return None

# --- Funciones de ayuda para inputs ---
def pedir_numero(msg):
    while True:
        try:
            val = input(msg)
            return int(val)
        except ValueError:
            print("Por favor, ingresa un número entero.")

def pedir_precio(msg):
    while True:
        try:
            val = input(msg)
            return float(val)
        except ValueError:
            print("Formato de precio incorrecto (usa punto para decimales).")

def pedir_texto(msg):
    while True:
        txt = input(msg).strip()
        if txt: return txt

# --- Lógica del Negocio ---

def menu_productos(conn):
    cursor = conn.cursor()
    while True:
        print("\n--- GESTIÓN DE PRODUCTOS ---")
        print("1. Agregar nuevo producto")
        print("2. Ver lista de productos")
        print("3. Actualizar Stock")
        print("4. Eliminar producto")
        print("0. Volver al menú principal")
        
        op = input("Seleccione una opción: ")

        if op == '1':
            nombre = pedir_texto("Nombre del producto: ")
            cat = pedir_texto("Categoría: ")
            precio = pedir_precio("Precio unitario: ")
            stock = pedir_numero("Stock inicial: ")
            
            sql = "INSERT INTO Productos (nombre, categoria, precio, stock) VALUES (%s, %s, %s, %s)"
            try:
                cursor.execute(sql, (nombre, cat, precio, stock))
                conn.commit()
                print(">> Producto guardado exitosamente.")
            except Exception as e:
                print(f"Error al guardar: {e}")

        elif op == '2':
            cursor.execute("SELECT * FROM Productos")
            lista = cursor.fetchall()
            print(f"\n{'ID':<5} {'Nombre':<25} {'Stock':<8} {'Precio'}")
            print("-" * 50)
            for p in lista:
                print(f"{p[0]:<5} {p[1]:<25} {p[4]:<8} ${p[3]}")

        elif op == '3':
            pid = pedir_numero("ID del producto a actualizar: ")
            n_stock = pedir_numero("Nuevo stock total: ")
            cursor.execute("UPDATE Productos SET stock = %s WHERE id_producto = %s", (n_stock, pid))
            conn.commit()
            if cursor.rowcount: print(">> Stock actualizado.")
            else: print(">> Producto no encontrado.")

        elif op == '4':
            pid = pedir_numero("ID del producto a eliminar: ")
            try:
                cursor.execute("DELETE FROM Productos WHERE id_producto = %s", (pid,))
                conn.commit()
                if cursor.rowcount: print(">> Producto eliminado.")
                else: print(">> ID no encontrado.")
            except:
                print(">> Error: No se puede borrar el producto porque ya tiene ventas registradas.")

        elif op == '0':
            break

def menu_clientes(conn):
    cursor = conn.cursor()
    while True:
        print("\n--- GESTIÓN DE CLIENTES ---")
        print("1. Registrar Cliente")
        print("2. Ver listado de Clientes")
        print("3. Actualizar contacto (Tel/Dir)")
        print("0. Volver")
        
        op = input("Opción: ")

        if op == '1':
            try:
                nom = pedir_texto("Nombre: ")
                ape = pedir_texto("Apellido: ")
                dni = pedir_texto("DNI: ")
                mail = pedir_texto("Email: ")
                tel = pedir_texto("Teléfono: ")
                dire = pedir_texto("Dirección: ")
                
                sql = "INSERT INTO Clientes (nombre, apellido, dni, email, telefono, direccion) VALUES (%s,%s,%s,%s,%s,%s)"
                cursor.execute(sql, (nom, ape, dni, mail, tel, dire))
                conn.commit()
                print(">> Cliente registrado.")
            except Exception as e:
                print(f"Error (posible DNI/Email repetido): {e}")

        elif op == '2':
            cursor.execute("SELECT id_cliente, nombre, apellido, dni, telefono FROM Clientes")
            print(f"\n{'ID':<5} {'Cliente':<25} {'DNI':<12} {'Teléfono'}")
            print("-" * 60)
            for c in cursor.fetchall():
                print(f"{c[0]:<5} {c[1]} {c[2]:<15} {c[3]:<12} {c[4]}")

        elif op == '3':
            cid = pedir_numero("ID del Cliente a editar: ")
            tel = pedir_texto("Nuevo Teléfono: ")
            dire = pedir_texto("Nueva Dirección: ")
            sql = "UPDATE Clientes SET telefono=%s, direccion=%s WHERE id_cliente=%s"
            cursor.execute(sql, (tel, dire, cid))
            conn.commit()
            print(">> Datos de contacto actualizados.")

        elif op == '0':
            break

def menu_ventas(conn):
    cursor = conn.cursor()
    print("\n--- MENÚ DE VENTAS ---")
    print("1. Crear Nueva Orden (Venta)")
    print("2. Ver historial de un Cliente")
    print("0. Volver")
    
    op = input("Opción: ")

    if op == '1':
        # Inicio de transacción
        if conn.in_transaction: conn.rollback()
        
        cid = pedir_numero("ID del Cliente: ")
        pid = pedir_numero("ID del Producto: ")
        cantidad = pedir_numero("Cantidad a vender: ")

        try:
            conn.start_transaction()

            # Verificar producto y stock (bloqueando fila para seguridad)
            cursor.execute("SELECT precio, stock, nombre FROM Productos WHERE id_producto = %s FOR UPDATE", (pid,))
            prod = cursor.fetchone()
            
            if not prod:
                print(">> Error: Producto no existe.")
                conn.rollback(); return

            precio_u, stock_actual, nom_prod = prod

            if stock_actual < cantidad:
                print(f">> Stock insuficiente. Solo quedan {stock_actual} unidades.")
                conn.rollback(); return

            # Verificar cliente
            cursor.execute("SELECT id_cliente FROM Clientes WHERE id_cliente = %s", (cid,))
            if not cursor.fetchone():
                print(">> Error: Cliente no encontrado.")
                conn.rollback(); return

            # Crear Orden y Detalle
            cursor.execute("INSERT INTO Ordenes (id_cliente, fecha) VALUES (%s, CURDATE())", (cid,))
            id_orden = cursor.lastrowid
            
            cursor.execute("INSERT INTO Detalles_Orden (id_orden, id_producto, cantidad, precio_unitario) VALUES (%s,%s,%s,%s)", 
                           (id_orden, pid, cantidad, precio_u))

            # Descontar Stock
            cursor.execute("UPDATE Productos SET stock = stock - %s WHERE id_producto = %s", (cantidad, pid))
            
            conn.commit()
            print(f">> Venta realizada con éxito. Orden #{id_orden}")

        except Exception as e:
            conn.rollback()
            print(f"Error en la transacción: {e}")

    elif op == '2':
        cid = pedir_numero("Ingrese ID del Cliente: ")
        sql = """
            SELECT o.id_orden, o.fecha, p.nombre, d.cantidad
            FROM Ordenes o
            JOIN Detalles_Orden d ON o.id_orden = d.id_orden
            JOIN Productos p ON d.id_producto = p.id_producto
            WHERE o.id_cliente = %s
            ORDER BY o.fecha DESC
        """
        cursor.execute(sql, (cid,))
        filas = cursor.fetchall()
        
        if filas:
            print(f"\nHistorial del Cliente #{cid}:")
            for f in filas:
                print(f"- Orden {f[0]} ({f[1]}): {f[2]} (Cant: {f[3]})")
        else:
            print(">> Este cliente no tiene compras registradas.")

def menu_busqueda(conn):
    cursor = conn.cursor()
    print("\n--- BÚSQUEDA AVANZADA ---")
    print("1. Buscar Producto por nombre")
    print("2. Buscar Cliente (Nombre/DNI)")
    op = input("Opción: ")

    if op == '1':
        q = pedir_texto("Texto a buscar: ")
        cursor.execute("SELECT * FROM Productos WHERE nombre LIKE %s", (f"%{q}%",))
        res = cursor.fetchall()
        print(f"Resultados: {len(res)}")
        for r in res: print(f"ID {r[0]} | {r[1]} | Stock: {r[4]} | ${r[3]}")

    elif op == '2':
        q = pedir_texto("Nombre, Apellido o DNI: ")
        sql = "SELECT * FROM Clientes WHERE nombre LIKE %s OR apellido LIKE %s OR dni LIKE %s"
        term = f"%{q}%"
        cursor.execute(sql, (term, term, term))
        res = cursor.fetchall()
        print(f"Resultados: {len(res)}")
        for r in res: print(f"ID {r[0]} | {r[1]} {r[2]} | DNI: {r[3]}")

def reporte_mas_vendido(conn):
    # Requerimiento 5
    cursor = conn.cursor()
    sql = """
        SELECT p.nombre, SUM(d.cantidad) as total
        FROM Detalles_Orden d
        JOIN Productos p ON d.id_producto = p.id_producto
        GROUP BY p.id_producto
        ORDER BY total DESC
        LIMIT 1
    """
    cursor.execute(sql)
    row = cursor.fetchone()
    if row:
        print(f"\n🏆 EL PRODUCTO MÁS VENDIDO ES: '{row[0]}' con {row[1]} unidades totales.")
    else:
        print("\n>> No hay datos suficientes para generar el reporte.")

def ajustar_ordenes(conn):
    # Requerimiento 6: Ajustar órdenes a una cantidad máxima
    print("\n--- AJUSTE DE CANTIDADES (AUDITORÍA) ---")
    pid = pedir_numero("ID del Producto a revisar: ")
    maximo = pedir_numero("Cantidad máxima permitida por orden: ")

    cursor = conn.cursor()
    try:
        sql = "UPDATE Detalles_Orden SET cantidad = %s WHERE id_producto = %s AND cantidad > %s"
        cursor.execute(sql, (maximo, pid, maximo))
        conn.commit()
        print(f">> Se han corregido {cursor.rowcount} registros de órdenes que excedían el límite.")
    except Exception as e:
        print(f"Error al ejecutar ajuste: {e}")

# --- Programa Principal ---
def main():
    conn = conectar()
    if not conn: return

    while True:
        print("\n" + "="*30)
        print("   SISTEMA DE VENTAS")
        print("="*30)
        print("1. Productos (Agregar, Stock, Eliminar)")
        print("2. Clientes (Registrar, Contacto)")
        print("3. Ventas y Órdenes")
        print("4. Búsquedas")
        print("5. Reporte: Más Vendido")
        print("6. Ajustar/Limitar Cantidades en Órdenes")
        print("7. Salir")
        
        opcion = input("\nElija una opción: ")

        if opcion == '1': menu_productos(conn)
        elif opcion == '2': menu_clientes(conn)
        elif opcion == '3': menu_ventas(conn)
        elif opcion == '4': menu_busqueda(conn)
        elif opcion == '5': reporte_mas_vendido(conn)
        elif opcion == '6': ajustar_ordenes(conn)
        elif opcion == '7':
            print("Cerrando sistema...")
            break
        else:
            print("Opción no válida, intente de nuevo.")

    conn.close()

if __name__ == "__main__":
    main()