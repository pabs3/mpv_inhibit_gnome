/*
 * This is a simple helper to allow D-Bus method calls
 */
#pragma once
#include <dbus/dbus.h>

typedef struct {
	DBusConnection *connection;
	DBusError *error;
} DBH;

DBH *DBH_init();

/*
 * Call a D-Bus method.
 * The result should be checked for errors and disposed of.
 */
DBusMessage *DBH_call(DBH *dbh, const char *name, const char *path,
                      const char *interface, const char *method_name,
                      int first_arg_type, ...);

void DBH_destroy(DBH *dbh);
