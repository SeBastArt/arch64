FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy-arm64v8 AS build-env
WORKDIR /app

# Copy everthing in src directory
COPY . ./
# Restore packages
RUN dotnet restore ./MqttInfluxBridgeServer/MqttInfluxBridgeServer.csproj --disable-parallel
# Build and publish release
RUN dotnet publish ./MqttInfluxBridgeServer/MqttInfluxBridgeServer.csproj -c Release -o out --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy-arm64v8
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 1883
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MqttInfluxBridgeServer.dll"]