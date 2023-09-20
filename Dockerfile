# Use the official ASP.NET Core runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["OptechXPortalAdminV2.csproj", "./"]
RUN dotnet restore "OptechXPortalAdminV2.csproj"
COPY . .
RUN dotnet build "OptechXPortalAdminV2.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "OptechXPortalAdminV2.csproj" -c Release -o /app/publish

# Build the final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OptechXPortalAdminV2.dll"]

