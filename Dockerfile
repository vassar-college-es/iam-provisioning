# Stage 1: Build the Jekyll site
FROM ruby:3.1 AS jekyll-build
WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN bundle exec jekyll build

# Stage 2: Serve with Nginx
FROM nginx:alpine
# Copy static assets from stage 1
COPY --from=jekyll-build /app/_site /usr/share/nginx/html

# Replace default start port from 80 to 8080, required for Cloud Run
RUN sed -i -e 's/listen\(.*\)80;/listen\18080;/g' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
