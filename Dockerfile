FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY jenkins/*.csproj ./jenkins/
RUN dotnet restore pipelines.csproj

# copy everything else and build app
COPY jenkins/. ./jenkins/
WORKDIR /app/jenkins
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/jenkins/out ./
ENTRYPOINT ["dotnet", "pipelines.dll"]