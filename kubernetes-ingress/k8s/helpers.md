# Dont forget who create the load Balancer is the ingrss controller

# If you want to rewrite target

Service /api-sales

mydomain.com/api-sales/get-users ->    Service/get-users
mydomain.com/api-sales/create-users -> Service/create-users

Service /customers

mydomain.com/customers/create-new-customer ->    Service/create-new-customer
mydomain.com/customers/validate-documents ->     Service/validate-documents


# Dont forget to point your domain (A record) to Load Balancer (Public IP)

