FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine-arm64v8 AS build-env
WORKDIR /app

# Copy everthing in src directory
COPY . ./
# Restore packages
RUN dotnet restore ./arch64.csproj --disable-parallel
# Build and publish release
RUN dotnet publish ./arch64.csproj -c Release -o out --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine-arm64v8
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 1883
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "arch64.dll"]