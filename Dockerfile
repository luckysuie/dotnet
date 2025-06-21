# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY lucky-webapp/*.csproj ./lucky-webapp/
RUN dotnet restore

# Copy everything else and build
COPY lucky-webapp/. ./lucky-webapp/
WORKDIR /app/lucky-webapp
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "luckywebapp.dll"]

