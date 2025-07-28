# Use the official Microsoft SQL Server image
FROM mcr.microsoft.com/mssql/server:2025-latest

# Set environment variables
ENV ACCEPT_EULA=Y

# Create app directory in a location the mssql user can access
USER root
RUN mkdir -p /opt/mssql-scripts
WORKDIR /opt/mssql-scripts

# Copy database initialization scripts
COPY mssql/db-init.sh ./
COPY mssql/db-init.sql ./
COPY mssql/entrypoint.sh ./

# Make scripts executable and change ownership to mssql user
RUN chmod +x db-init.sh entrypoint.sh
RUN chown -R mssql:mssql /opt/mssql-scripts

# Switch back to mssql user
USER mssql

# Expose SQL Server port
EXPOSE 1433

# Run the entrypoint script
CMD ["./entrypoint.sh"]
