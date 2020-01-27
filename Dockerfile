FROM element6team/frappe

LABEL maintainer="team@element6.dev"
LABEL version="1.0"
LABEL description="ERPNext on frappe"

ENV siteName=foo.bar
ENV mysqlHost=mariadb
ENV mysqlPass=123456789
ENV adminPass=123456789
ENV erpnextBranch=version-12

# Mariadb is not on same container
RUN sed -i '$s/}/,\n"db_host":"'$mysqlHost'"}/' ./frappe-bench/sites/common_site_config.json
WORKDIR ./frappe-bench

# Create new site
RUN bench new-site $siteName \
    --mariadb-root-password $mysqlPass \
    --admin-password $adminPass

# Install ERPNext
RUN bench get-app --branch $erpnextBranch erpnext
RUN ./env/bin/pip3 install -e apps/erpnext/

# Add ERPNext to site
RUN bench --site $siteName install-app erpnext

# Start bench
EXPOSE 8000

CMD [ "bench", "start"]