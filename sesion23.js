


{
  "ClienteID": 1,
  "Nombre": "Juan Pérez",
  "Ciudad": "Santiago",
  "Pedidos": [
    {
      "PedidoID": 101,
      "Total": 2272.5,
      "Detalles": [
        { "ProductoID": 1, "Nombre": "Laptop", "Precio": 1200, "Cantidad": 2 },
        { "ProductoID": 2, "Nombre": "Mouse", "Precio": 25, "Cantidad": 5 }
      ]
    }
  ]
}

// a. Obtener clientes de Santiago [cite: 943]
db.clientes.find({ "Ciudad": "Santiago" });

// b. Calcular total de productos vendidos [cite: 945]
db.clientes.aggregate([
    { $unwind: "$Pedidos" },
    { $unwind: "$Pedidos.Detalles" },
    {
        $group: {
            _id: "$Pedidos.Detalles.Nombre",
            TotalVendidos: { $sum: "$Pedidos.Detalles.Cantidad" }
        }
    }
]);