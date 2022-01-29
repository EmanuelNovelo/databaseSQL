#143.198.149.81
library(RMySQL)

connect_own<-function() {
  
  options(mysql = list(
    "host" = "143.198.149.81", 
    "port" = 3306,
    "user" = "emanuel",
    "password" = "P@ssword1213"
    
  ))
  
  
  db <- RMySQL::dbConnect(RMySQL::MySQL(), dbname = "clase", host = options()$mysql$host, 
                          port = options()$mysql$port, user = options()$mysql$user, 
                          password = options()$mysql$password)  
  
  
  
  return(db)
}

con_own <- connect_own()

connect_roberto<-function() {
  
  options(mysql = list(
    "host" = "206.189.165.210", 
    "port" = 3306,
    "user" = "emanuel",
    "password" = "P@ssword1213"
    
  ))
  
  
  db <- RMySQL::dbConnect(RMySQL::MySQL(), dbname = "clase", host = options()$mysql$host, 
                          port = options()$mysql$port, user = options()$mysql$user, 
                          password = options()$mysql$password)  
  
  
  
  return(db)
}

con_roberto <- connect_roberto()

#-----------------------------------------SECCION DE PRUEBAS----

dbListTables(con_own)
dbListTables(con_roberto )

#dbListFields(con_own, "heart_data")   #observar el error de esta linea
dbListFields(con_roberto, "heart_data")

#res <- dbSendQuery(con_own, "SELECT * FROM heart_data")
#dbFetch(res)
res1 <- dbSendQuery(con_roberto, "SELECT * FROM heart_data")
dbFetch(res1)

#dbDisconnect(con_roberto)   #siempre cerrar la conexion cualquier pdo

#----

#-----------------------------------------TERMINO SECCION DE PRUEBAS----

#automatizacion de extraccion de datos del servidor de Roberto
read_table_from_roberto <- function(table_name) {
  
  con <- connect_roberto()
  
  res <- dbSendQuery(con, paste0("SELECT * FROM ", table_name))
  table <- dbFetch(res)
  
  dbDisconnect(con)
  
  return(table)
  
}

datos <- read_table_from_roberto("heart_data")
#la funcion creada previamente ya existe predefinida como dbReadTable()

heart_data <- dbReadTable(con_roberto, "heart_data")  #funcion definida de paqueteria, mismo resultado que la que se creo arriba

#uploading db to mysql server
dbWriteTable(con_own, "heart_data", heart_data, overwrite = TRUE, row.names=FALSE)
dbListTables(con_own)


#------------------- EJERICCIO 1 - pasar insurance_analysis y Segmentacion clientes a mi servidor----

insur <- dbReadTable(con_roberto, "insurance_analysis")  
segm <- dbReadTable(con_roberto, "segmentacionclientes")

#uploading db to mysql server
dbWriteTable(con_own, "insurance_analysis", insur, overwrite = TRUE, row.names=FALSE)
dbWriteTable(con_own, "segmentacionclientes", segm, overwrite = TRUE, row.names=FALSE)
dbListTables(con_own)


