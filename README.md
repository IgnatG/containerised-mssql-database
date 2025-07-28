# Containerised MSSQL Database

A ready-to-use containerized SQL Server database with sample marketplace data. Perfect for development, testing, and prototyping e-commerce applications.

## 🚀 Quick Start

```bash
# Clone and navigate to the project
git clone <repository-url>
cd containerised-mssql-database

# Start the database (recommended)
docker compose up --build -d

# Verify it's running
docker compose logs mssql
```

## 📋 Prerequisites

- Docker Desktop installed and running
- At least 2GB available RAM for SQL Server
- Port 1433 available (or modify docker-compose.yml to use a different port)

## 🗄️ Database Schema

The database (`SampleMarketDB`) contains a complete marketplace data model:

| Table | Description | Key Fields |
|-------|-------------|------------|
| `categories` | Product categories | id, name, description |
| `suppliers` | Supplier companies | id, name, contact_email, phone |
| `products` | Store inventory | id, name, category_id, supplier_id, price |
| `inventory` | Stock levels | product_id, quantity, last_updated |
| `customers` | Customer accounts | id, first_name, last_name, email |
| `orders` | Purchase orders | id, customer_id, order_date, total_amount |
| `order_items` | Order line items | order_id, product_id, quantity, unit_price |

### Entity Relationships

- Products belong to Categories and Suppliers
- Inventory tracks quantity for each Product
- Orders are placed by Customers
- Order Items link Orders to Products with quantities

## ⚙️ Setup Options

### 🐳 Docker Compose (Recommended)

Simplest way to get started:

```bash
# Start in detached mode
docker compose up --build -d

# View logs
docker compose logs -f mssql

# Stop services
docker compose down
```

### 🔧 Manual Docker Build

For more control over the process:

1. Build the Docker image:

```bash
docker build -t mssql-sample-marketplace .
```

1. Run the container:

```bash
docker run -d \
  --name mssql-server \
  -p 1433:1433 \
  -e MSSQL_SA_PASSWORD=Password123!! \
  -e ACCEPT_EULA=Y \
  mssql-sample-marketplace
```

## 🔗 Database Connection

**Connection Details:**

- **Host:** `localhost` (or `host.docker.internal` from other containers)
- **Port:** `1433`
- **Database:** `SampleMarketDB`
- **Username:** `SA`
- **Password:** `Password123!!`

**Connection String Examples:**

```bash
# SQL Server Management Studio (SSMS)
Server: localhost,1433
Database: SampleMarketDB
Authentication: SQL Server Authentication
Login: SA
Password: Password123!!
```

```csharp
// .NET Connection String
"Server=localhost,1433;Database=SampleMarketDB;User Id=SA;Password=Password123!!;TrustServerCertificate=true;"
```

```javascript
// Node.js (mssql package)
{
  server: 'localhost',
  port: 1433,
  database: 'SampleMarketDB',
  user: 'SA',
  password: 'Password123!!',
  options: {
    encrypt: true,
    trustServerCertificate: true
  }
}
```

⏱️ **Important:** Wait 60-90 seconds after starting the container for complete database initialization.

## 📊 Sample Data

The database comes pre-loaded with realistic test data:

| Data Type | Count | Examples |
|-----------|-------|----------|
| **Categories** | 5 | Beverages, Bakery, Dairy, Produce, Meat & Seafood |
| **Suppliers** | 4 | FreshFarms Ltd., OceanCatch, BakeHouse Supplies |
| **Products** | 5 | Orange Juice (£1.99), Salmon Fillet (£5.99) |
| **Customers** | 3 | Emma Brown, James Wilson, Olivia Taylor |
| **Orders** | 3 | Recent orders with multiple items |

### Quick Data Exploration

```sql
-- View all products with categories and suppliers
SELECT p.name, c.name as category, s.name as supplier, p.price
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON p.supplier_id = s.id;

-- Check current inventory levels
SELECT p.name, i.quantity, i.last_updated
FROM products p
JOIN inventory i ON p.id = i.product_id;

-- Recent orders summary
SELECT o.id, c.first_name + ' ' + c.last_name as customer, 
       o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id;
```

## 🛠️ Development Workflow

### Making Schema Changes

1. **Modify** `mssql/db-init.sql` with your changes
2. **Rebuild** the container:

   ```bash
   docker compose down
   docker compose up --build -d
   ```

3. **Verify** changes by connecting to the database

### Adding Sample Data

Edit the INSERT statements in `mssql/db-init.sql` and rebuild the container.

### Backup/Restore

```bash
# Create a backup
docker exec mssql-server /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U SA -P 'Password123!!' \
  -Q "BACKUP DATABASE SampleMarketDB TO DISK = '/tmp/backup.bak'"

# Copy backup to host
docker cp mssql-server:/tmp/backup.bak ./backup.bak
```

## 🔧 Troubleshooting

### Container Won't Start

```bash
# Check container logs
docker compose logs mssql

# Common issues:
# - Port 1433 already in use (change port in docker-compose.yml)
# - Insufficient memory (ensure Docker has 2GB+ allocated)
# - EULA not accepted (check environment variables)
```

### Connection Issues

```bash
# Test connection from command line
docker exec -it mssql-server /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U SA -P 'Password123!!'

# From host machine (requires sqlcmd installed)
sqlcmd -S localhost,1433 -U SA -P 'Password123!!'
```

### Database Not Initialized

```bash
# Check if initialization completed
docker exec mssql-server ls -la /opt/mssql-scripts/

# Re-run initialization manually
docker exec -it mssql-server /opt/mssql-scripts/entrypoint.sh
```

## 🧹 Cleanup

```bash
# Stop and remove containers, networks, and volumes
docker compose down -v

# Remove the built image (optional)
docker rmi mssql-sample-marketplace

# Clean up any remaining containers
docker stop mssql-server
docker rm mssql-server
```

## 📚 Additional Resources

- [SQL Server in Docker Documentation](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-deployment)
- [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) - Cross-platform SQL Server tool

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes to `mssql/db-init.sql` or other files
4. Test your changes by rebuilding the container
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

---

💡 **Pro Tip:** Use this database for rapid prototyping of e-commerce applications, testing ORMs, or learning SQL Server features!
