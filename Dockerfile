# Jaspr SSR build
FROM dart:stable AS build
WORKDIR /app
RUN dart pub global activate jaspr_cli
ENV PATH="$PATH:/root/.pub-cache/bin"
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN jaspr build

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/build/jaspr/ /app/
EXPOSE 8080
CMD ["./app"]
