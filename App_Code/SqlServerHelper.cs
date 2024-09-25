using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
    public static class SqlServerHelper
    {
        private const string nullParameterMessage = "Null value cannot be assigned to a non-nullable type.";

        private static SqlConnection connection;

        private static string connectionString =
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        private static SqlTransaction transaction;

        public static string ConnectionString
        {
            get { return connectionString; }
            set { connectionString = value; }
        }

        public static SqlConnection Connection
        {
            get { return connection; }
            set { connection = value; }
        }

        public static SqlTransaction Transaction
        {
            get { return transaction; }
            set { transaction = value; }
        }

        #region Nullable Type Conversions

        public static Boolean? ToNullableBoolean(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlBoolean))
            {
                return Convert.ToBoolean(sqlParameter.Value);
            }
            SqlBoolean sqlBoolean = (SqlBoolean) sqlParameter.Value;
            if (sqlBoolean.IsNull)
                return null;
            return sqlBoolean.IsTrue;
        }

        public static Boolean? ToNullableBoolean(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToBoolean(o);
        }

        public static Byte? ToNullableByte(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (sqlParameter.Value is SqlByte)
            {
                SqlByte sqlByte = (SqlByte) sqlParameter.Value;
                if (sqlByte.IsNull)
                    return null;
                return sqlByte.Value;
            }
            return Convert.ToByte(sqlParameter.Value);
        }

        public static Byte? ToNullableByte(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToByte(o);
        }

        public static Int16? ToNullableInt16(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlInt16))
            {
                return Convert.ToInt16(sqlParameter.Value);
            }
            SqlInt16 sqlInt16 = (SqlInt16) sqlParameter.Value;
            return sqlInt16.IsNull ? (short?) null : sqlInt16.Value;
        }

        public static Int16? ToNullableInt16(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToInt16(o);
        }

        public static Int32? ToNullableInt32(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlInt32))
                return Convert.ToInt32(sqlParameter.Value);
            SqlInt32 sqlInt32 = (SqlInt32) sqlParameter.Value;
            if (sqlInt32.IsNull)
                return null;
            return sqlInt32.Value;
        }

        public static Int32? ToNullableInt32(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToInt32(o);
        }

        public static Int64? ToNullableInt64(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlInt64))
                return Convert.ToInt64(sqlParameter.Value);
            SqlInt64 sqlInt64 = (SqlInt64) sqlParameter.Value;
            return sqlInt64.IsNull ? (long?) null : sqlInt64.Value;
        }

        public static Int64? ToNullableInt64(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToInt64(o);
        }

        public static Decimal? ToNullableDecimal(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlDecimal))
                return Convert.ToDecimal(sqlParameter.Value);
            SqlDecimal sqlDecimal = (SqlDecimal) sqlParameter.Value;
            return sqlDecimal.IsNull ? (decimal?) null : sqlDecimal.Value;
        }

        public static Decimal? ToNullableDecimal(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToDecimal(o);
        }

        public static Single? ToNullableSingle(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlSingle))
                return Convert.ToSingle(sqlParameter.Value);
            SqlSingle sqlSingle = (SqlSingle) sqlParameter.Value;
            if (sqlSingle.IsNull)
                return null;
            return sqlSingle.Value;
        }

        public static Single? ToNullableSingle(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToSingle(o);
        }

        public static Double? ToNullableDouble(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlDouble))
                return Convert.ToDouble(sqlParameter.Value);
            SqlDouble sqlDouble = (SqlDouble) sqlParameter.Value;
            if (sqlDouble.IsNull)
                return null;
            return sqlDouble.Value;
        }

        public static Double? ToNullableDouble(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToDouble(o);
        }

        public static DateTime? ToNullableDateTime(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlDateTime))
                return Convert.ToDateTime(sqlParameter.Value);
            SqlDateTime sqlDateTime = (SqlDateTime) sqlParameter.Value;
            if (sqlDateTime.IsNull)
                return null;
            return sqlDateTime.Value;
        }

        public static DateTime? ToNullableDateTime(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return Convert.ToDateTime(o);
        }

        public static Guid? ToNullableGuid(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlGuid))
            {
                return (Guid) sqlParameter.Value;
            }
            SqlGuid sqlGuid = (SqlGuid) sqlParameter.Value;
            if (sqlGuid.IsNull)
                return null;
            return sqlGuid.Value;
        }

        public static Guid? ToNullableGuid(object o)
        {
            if ((o == null) || (o is DBNull))
                return null;
            return o is byte[] ? new Guid((byte[]) o) : new Guid(Convert.ToString(o));
        }

        #endregion

        #region Stream and Reference Type Conversions

        public static Byte[] ToByteArray(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && sqlParameter.Value == null)
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (sqlParameter.Value is SqlBinary)
            {
                SqlBinary sqlBinary = (SqlBinary) sqlParameter.Value;
                return sqlBinary.IsNull ? null : sqlBinary.Value;
            }
            if (!(sqlParameter.Value is SqlBytes))
            {
                return (byte[]) sqlParameter.Value;
            }
            SqlBytes sqlBytes = (SqlBytes) sqlParameter.Value;
            return sqlBytes.IsNull ? null : sqlBytes.Value;
        }

        public static String ToString(SqlParameter sqlParameter)
        {
            if (sqlParameter.IsNullable && (sqlParameter.Value == null))
                return null;
            if (sqlParameter.Value.Equals(DBNull.Value))
                return null;
            if (!(sqlParameter.Value is SqlString))
            {
                return Convert.ToString(sqlParameter.Value);
            }
            SqlString sqlString = (SqlString) sqlParameter.Value;
            return sqlString.IsNull ? null : sqlString.Value;
        }

        public static Int64 ToStream(SqlParameter sqlParameter, Stream stream)
        {
            long bytesStreamed = 0;
            using (stream)
            {
                try
                {
                    if (sqlParameter.IsNullable && sqlParameter.Value == null)
                        return bytesStreamed;
                    else if (sqlParameter.Value.Equals(DBNull.Value))
                        return bytesStreamed;
                    else if (sqlParameter.Value is SqlBinary)
                    {
                        SqlBinary sqlBinary = (SqlBinary) sqlParameter.Value;
                        if (!sqlBinary.IsNull)
                        {
                            stream.Write(sqlBinary.Value, 0, sqlBinary.Length);
                            bytesStreamed = sqlBinary.Length;
                        }
                    }
                    else if (sqlParameter.Value is SqlBytes)
                    {
                        SqlBytes sqlBytes = (SqlBytes) sqlParameter.Value;
                        if (!sqlBytes.IsNull)
                        {
                            if (sqlBytes.Storage == StorageState.Buffer)
                            {
                                stream.Write(sqlBytes.Value, 0, (int) sqlBytes.Length);
                                bytesStreamed = sqlBytes.Length;
                            }
                            else
                            {
                                byte[] buffer = new byte[8192];
                                int bytesRead;
                                long offset = 0;
                                while ((bytesRead = (int) sqlBytes.Read(offset, buffer, 0, 8192)) > 0)
                                {
                                    stream.Write(buffer, 0, bytesRead);
                                    offset += bytesRead;
                                    bytesStreamed += bytesRead;
                                }
                                sqlBytes.Stream.Close();
                            }
                        }
                    }
                    else
                    {
                        byte[] buffer = (byte[]) sqlParameter.Value;
                        stream.Write(buffer, 0, buffer.Length);
                        bytesStreamed = buffer.Length;
                    }
                }
                finally
                {
                    stream.Close();
                }
                return bytesStreamed;
            }
        }

        #endregion

        #region Non-Nullable Value Type Conversions

        public static Boolean ToBoolean(SqlParameter sqlParameter, Boolean defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlBoolean) && ((SqlBoolean) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            if (sqlParameter.Value is SqlBoolean)
            {
                return ((SqlBoolean) sqlParameter.Value).IsTrue;
            }
            return Convert.ToBoolean(sqlParameter.Value);
        }

        public static Boolean ToBoolean(SqlParameter sqlParameter)
        {
            return ToBoolean(sqlParameter, false, true);
        }

        public static Boolean ToBoolean(SqlParameter sqlParameter, Boolean defaultValue)
        {
            return ToBoolean(sqlParameter, defaultValue, false);
        }

        public static Boolean ToBoolean(object o)
        {
            return Convert.ToBoolean(o);
        }

        public static Byte ToByte(SqlParameter sqlParameter, Byte defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlByte) && ((SqlByte) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlByte
                       ? ((SqlByte) sqlParameter.Value).Value
                       : Convert.ToByte(sqlParameter.Value);
        }

        public static Byte ToByte(SqlParameter sqlParameter)
        {
            return ToByte(sqlParameter, Byte.MinValue, true);
        }

        public static Byte ToByte(SqlParameter sqlParameter, Byte defaultValue)
        {
            return ToByte(sqlParameter, defaultValue, false);
        }

        public static Byte ToByte(object o)
        {
            return Convert.ToByte(o);
        }

        public static Int16 ToInt16(SqlParameter sqlParameter, Int16 defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlInt16) && ((SqlInt16) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlInt16
                       ? ((SqlInt16) sqlParameter.Value).Value
                       : Convert.ToInt16(sqlParameter.Value);
        }

        public static Int16 ToInt16(SqlParameter sqlParameter)
        {
            return ToInt16(sqlParameter, Int16.MinValue, true);
        }

        public static Int16 ToInt16(SqlParameter sqlParameter, Int16 defaultValue)
        {
            return ToInt16(sqlParameter, defaultValue, false);
        }

        public static Int16 ToInt16(object o)
        {
            return Convert.ToInt16(o);
        }

        public static Int32 ToInt32(SqlParameter sqlParameter, Int32 defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlInt32) && ((SqlInt32) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlInt32
                       ? ((SqlInt32) sqlParameter.Value).Value
                       : Convert.ToInt32(sqlParameter.Value);
        }

        public static Int32 ToInt32(SqlParameter sqlParameter)
        {
            return ToInt32(sqlParameter, Int32.MinValue, true);
        }

        public static Int32 ToInt32(SqlParameter sqlParameter, Int32 defaultValue)
        {
            return ToInt32(sqlParameter, defaultValue, false);
        }

        public static Int32 ToInt32(object o)
        {
            return Convert.ToInt32(o);
        }

        public static Int64 ToInt64(SqlParameter sqlParameter, Int64 defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlInt64) && ((SqlInt64) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            if (sqlParameter.Value is SqlInt64)
            {
                return ((SqlInt64) sqlParameter.Value).Value;
            }
            return Convert.ToInt64(sqlParameter.Value);
        }

        public static Int64 ToInt64(SqlParameter sqlParameter)
        {
            return ToInt64(sqlParameter, Int64.MinValue, true);
        }

        public static Int64 ToInt64(SqlParameter sqlParameter, Int64 defaultValue)
        {
            return ToInt64(sqlParameter, defaultValue, false);
        }

        public static Int64 ToInt64(object o)
        {
            return Convert.ToInt64(o);
        }

        public static Decimal ToDecimal(SqlParameter sqlParameter, Decimal defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlDecimal) && ((SqlDecimal) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlDecimal
                       ? ((SqlDecimal) sqlParameter.Value).Value
                       : Convert.ToDecimal(sqlParameter.Value);
        }

        public static Decimal ToDecimal(SqlParameter sqlParameter)
        {
            return ToDecimal(sqlParameter, Decimal.MinValue, true);
        }

        public static Decimal ToDecimal(SqlParameter sqlParameter, Decimal defaultValue)
        {
            return ToDecimal(sqlParameter, defaultValue, false);
        }


        public static Decimal ToDecimal(object o)
        {
            return Convert.ToDecimal(o);
        }

        public static Single ToSingle(SqlParameter sqlParameter, Single defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlSingle) && ((SqlSingle) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            if (sqlParameter.Value is SqlSingle)
            {
                return ((SqlSingle) sqlParameter.Value).Value;
            }
            return Convert.ToSingle(sqlParameter.Value);
        }

        public static Single ToSingle(SqlParameter sqlParameter)
        {
            return ToSingle(sqlParameter, Single.MinValue, true);
        }

        public static Single ToSingle(SqlParameter sqlParameter, Single defaultValue)
        {
            return ToSingle(sqlParameter, defaultValue, false);
        }

        public static Single ToSingle(object o)
        {
            return Convert.ToSingle(o);
        }

        public static Double ToDouble(SqlParameter sqlParameter, Double defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlDouble) && ((SqlDouble) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            if (sqlParameter.Value is SqlDouble)
            {
                return ((SqlDouble) sqlParameter.Value).Value;
            }
            return Convert.ToDouble(sqlParameter.Value);
        }

        public static Double ToDouble(SqlParameter sqlParameter)
        {
            return ToDouble(sqlParameter, Double.MinValue, true);
        }

        public static Double ToDouble(SqlParameter sqlParameter, Double defaultValue)
        {
            return ToDouble(sqlParameter, defaultValue, false);
        }

        public static Double ToDouble(object o)
        {
            return Convert.ToDouble(o);
        }

        public static DateTime ToDateTime(SqlParameter sqlParameter, DateTime defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlDateTime) && ((SqlDateTime) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlDateTime
                       ? ((SqlDateTime) sqlParameter.Value).Value
                       : Convert.ToDateTime(sqlParameter.Value);
        }

        public static DateTime ToDateTime(SqlParameter sqlParameter)
        {
            return ToDateTime(sqlParameter, DateTime.MinValue, true);
        }

        public static DateTime ToDateTime(SqlParameter sqlParameter, DateTime defaultValue)
        {
            return ToDateTime(sqlParameter, defaultValue, false);
        }

        public static DateTime ToDateTime(object o)
        {
            return Convert.ToDateTime(o);
        }

        public static Guid ToGuid(SqlParameter sqlParameter, Guid defaultValue, Boolean throwExceptionOnNull)
        {
            if ((sqlParameter.IsNullable && (sqlParameter.Value == null)) ||
                (sqlParameter.Value.Equals(DBNull.Value)) ||
                ((sqlParameter.Value is SqlGuid) && ((SqlGuid) sqlParameter.Value).IsNull))
            {
                if (throwExceptionOnNull)
                    throw new NullReferenceException(nullParameterMessage);
                return defaultValue;
            }
            return sqlParameter.Value is SqlGuid ? ((SqlGuid) sqlParameter.Value).Value : (Guid) sqlParameter.Value;
        }

        public static Guid ToGuid(SqlParameter sqlParameter)
        {
            return ToGuid(sqlParameter, Guid.Empty, true);
        }

        public static Guid ToGuid(SqlParameter sqlParameter, Guid defaultValue)
        {
            return ToGuid(sqlParameter, defaultValue, false);
        }

        public static Guid ToGuid(object o)
        {
            if (o is byte[])
            {
                return new Guid((byte[]) o);
            }
            return new Guid(Convert.ToString(o));
        }

        #endregion

        #region Nullable Parameter Value Setting Routines

        public static void SetParameterValue(SqlParameter sqlParameter, Boolean? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlBoolean(value.Value) : SqlBoolean.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Byte? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlByte(value.Value) : SqlByte.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int16? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlInt16(value.Value) : SqlInt16.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int32? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlInt32(value.Value) : SqlInt32.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int64? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlInt64(value.Value) : SqlInt64.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Decimal? value)
        {
            if (value.HasValue)
                sqlParameter.Value = value.Value;
            else
                sqlParameter.Value = DBNull.Value;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Single? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlSingle(value.Value) : SqlSingle.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Double? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlDouble(value.Value) : SqlDouble.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, DateTime? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlDateTime(value.Value) : SqlDateTime.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Guid? value)
        {
            sqlParameter.Value = value.HasValue ? new SqlGuid(value.Value) : SqlGuid.Null;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, String value)
        {
            sqlParameter.Value = value == null ? SqlString.Null : new SqlString(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Stream value)
        {
            sqlParameter.Value = value == null ? SqlBytes.Null : new SqlBytes(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Byte[] value)
        {
            sqlParameter.Value = value == null ? SqlBinary.Null : new SqlBinary(value);
        }

        #endregion

        #region Non Nullable Parameter Value Setting Routines

        public static void SetParameterValue(SqlParameter sqlParameter, Boolean value)
        {
            sqlParameter.Value = new SqlBoolean(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Boolean value, Boolean nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlBoolean.Null : new SqlBoolean(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Byte value)
        {
            sqlParameter.Value = new SqlByte(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Byte value, Byte nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlByte.Null : new SqlByte(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int16 value)
        {
            sqlParameter.Value = new SqlInt16(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int16 value, Int16 nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlInt16.Null : new SqlInt16(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int32 value)
        {
            sqlParameter.Value = new SqlInt32(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int32 value, Int32 nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlInt32.Null : new SqlInt32(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int64 value)
        {
            sqlParameter.Value = new SqlInt64(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Int64 value, Int64 nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlInt64.Null : new SqlInt64(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Decimal value)
        {
            sqlParameter.Value = value;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Decimal value, Decimal nullEquivalent)
        {
            if (value == nullEquivalent)
                sqlParameter.Value = DBNull.Value;
            else
                sqlParameter.Value = value;
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Single value)
        {
            sqlParameter.Value = new SqlSingle(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Single value, Single nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlSingle.Null : new SqlSingle(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Double value)
        {
            sqlParameter.Value = new SqlDouble(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Double value, Double nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlDouble.Null : new SqlDouble(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, DateTime value)
        {
            sqlParameter.Value = new SqlDateTime(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, DateTime value, DateTime nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlDateTime.Null : new SqlDateTime(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Guid value)
        {
            sqlParameter.Value = new SqlGuid(value);
        }

        public static void SetParameterValue(SqlParameter sqlParameter, Guid value, Guid nullEquivalent)
        {
            sqlParameter.Value = value == nullEquivalent ? SqlGuid.Null : new SqlGuid(value);
        }

        #endregion

        #region Nullable Data Reader Conversions

        public static Boolean? ToNullableBoolean(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetBoolean(ordinal);
        }

        public static Boolean? ToNullableBoolean(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableBoolean(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Byte? ToNullableByte(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetByte(ordinal);
        }

        public static Byte? ToNullableByte(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableByte(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int16? ToNullableInt16(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetInt16(ordinal);
        }

        public static Int16? ToNullableInt16(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableInt16(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int32? ToNullableInt32(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetInt32(ordinal);
        }

        public static Int32? ToNullableInt32(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableInt32(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int64? ToNullableInt64(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetInt64(ordinal);
        }

        public static Int64? ToNullableInt64(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableInt64(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Decimal? ToNullableDecimal(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetDecimal(ordinal);
        }

        public static Decimal? ToNullableDecimal(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableDecimal(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Single? ToNullableSingle(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetFloat(ordinal);
        }

        public static Single? ToNullableSingle(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableSingle(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Double? ToNullableDouble(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetDouble(ordinal);
        }

        public static Double? ToNullableDouble(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableDouble(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static DateTime? ToNullableDateTime(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetDateTime(ordinal);
        }

        public static DateTime? ToNullableDateTime(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableDateTime(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Guid? ToNullableGuid(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetGuid(ordinal);
        }

        public static Guid? ToNullableGuid(SqlDataReader sqlDataReader, string columnName)
        {
            return ToNullableGuid(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static String ToString(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetString(ordinal);
        }

        public static String ToString(SqlDataReader sqlDataReader, string columnName)
        {
            return ToString(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static byte[] ToByteArray(SqlDataReader sqlDataReader, int ordinal)
        {
            if ((ordinal < 0) || sqlDataReader.IsDBNull(ordinal))
                return null;
            return sqlDataReader.GetSqlBinary(ordinal).Value;
        }

        public static byte[] ToByteArray(SqlDataReader sqlDataReader, string columnName)
        {
            return ToByteArray(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        #endregion

        #region Non-Nullable Data Reader Conversions

        public static Boolean ToBoolean(SqlDataReader sqlDataReader, int ordinal, Boolean defaultValue,
                                        Boolean throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetBoolean(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Boolean ToBoolean(SqlDataReader sqlDataReader, int ordinal, Boolean defaultValue)
        {
            return ToBoolean(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Boolean ToBoolean(SqlDataReader sqlDataReader, string columnName, Boolean defaultValue)
        {
            return ToBoolean(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Boolean ToBoolean(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToBoolean(sqlDataReader, ordinal, false, true);
        }

        public static Boolean ToBoolean(SqlDataReader sqlDataReader, string columnName)
        {
            return ToBoolean(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Byte ToByte(SqlDataReader sqlDataReader, int ordinal, Byte defaultValue, bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetByte(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Byte ToByte(SqlDataReader sqlDataReader, int ordinal, Byte defaultValue)
        {
            return ToByte(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Byte ToByte(SqlDataReader sqlDataReader, string columnName, Byte defaultValue)
        {
            return ToByte(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Byte ToByte(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToByte(sqlDataReader, ordinal, Byte.MinValue, true);
        }

        public static Byte ToByte(SqlDataReader sqlDataReader, string columnName)
        {
            return ToByte(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int16 ToInt16(SqlDataReader sqlDataReader, int ordinal, Int16 defaultValue,
                                    bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetInt16(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Int16 ToInt16(SqlDataReader sqlDataReader, int ordinal, Int16 defaultValue)
        {
            return ToInt16(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Int16 ToInt16(SqlDataReader sqlDataReader, string columnName, Int16 defaultValue)
        {
            return ToInt16(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Int16 ToInt16(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToInt16(sqlDataReader, ordinal, Int16.MinValue, true);
        }

        public static Int16 ToInt16(SqlDataReader sqlDataReader, string columnName)
        {
            return ToInt16(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int32 ToInt32(SqlDataReader sqlDataReader, int ordinal, Int32 defaultValue,
                                    bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetInt32(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Int32 ToInt32(SqlDataReader sqlDataReader, int ordinal, Int32 defaultValue)
        {
            return ToInt32(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Int32 ToInt32(SqlDataReader sqlDataReader, string columnName, Int32 defaultValue)
        {
            return ToInt32(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Int32 ToInt32(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToInt32(sqlDataReader, ordinal, Int32.MinValue, true);
        }

        public static Int32 ToInt32(SqlDataReader sqlDataReader, string columnName)
        {
            return ToInt32(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Int64 ToInt64(SqlDataReader sqlDataReader, int ordinal, Int64 defaultValue,
                                    bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetInt64(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Int64 ToInt64(SqlDataReader sqlDataReader, int ordinal, Int64 defaultValue)
        {
            return ToInt64(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Int64 ToInt64(SqlDataReader sqlDataReader, string columnName, Int64 defaultValue)
        {
            return ToInt64(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Int64 ToInt64(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToInt64(sqlDataReader, ordinal, Int64.MinValue, true);
        }

        public static Int64 ToInt64(SqlDataReader sqlDataReader, string columnName)
        {
            return ToInt64(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Decimal ToDecimal(SqlDataReader sqlDataReader, int ordinal, Decimal defaultValue,
                                        bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetDecimal(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Decimal ToDecimal(SqlDataReader sqlDataReader, int ordinal, Decimal defaultValue)
        {
            return ToDecimal(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Decimal ToDecimal(SqlDataReader sqlDataReader, string columnName, Decimal defaultValue)
        {
            return ToDecimal(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Decimal ToDecimal(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToDecimal(sqlDataReader, ordinal, Decimal.MinValue, true);
        }

        public static Decimal ToDecimal(SqlDataReader sqlDataReader, string columnName)
        {
            return ToDecimal(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Single ToSingle(SqlDataReader sqlDataReader, int ordinal, Single defaultValue,
                                      bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetFloat(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Single ToSingle(SqlDataReader sqlDataReader, int ordinal, Single defaultValue)
        {
            return ToSingle(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Single ToSingle(SqlDataReader sqlDataReader, string columnName, Single defaultValue)
        {
            return ToSingle(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Single ToSingle(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToSingle(sqlDataReader, ordinal, Single.MinValue, true);
        }

        public static Single ToSingle(SqlDataReader sqlDataReader, string columnName)
        {
            return ToSingle(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Double ToDouble(SqlDataReader sqlDataReader, int ordinal, Double defaultValue,
                                      bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetDouble(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Double ToDouble(SqlDataReader sqlDataReader, int ordinal, Double defaultValue)
        {
            return ToDouble(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Double ToDouble(SqlDataReader sqlDataReader, string columnName, Double defaultValue)
        {
            return ToDouble(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Double ToDouble(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToDouble(sqlDataReader, ordinal, Double.MinValue, true);
        }

        public static Double ToDouble(SqlDataReader sqlDataReader, string columnName)
        {
            return ToDouble(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static DateTime ToDateTime(SqlDataReader sqlDataReader, int ordinal, DateTime defaultValue,
                                          bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetDateTime(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static DateTime ToDateTime(SqlDataReader sqlDataReader, int ordinal, DateTime defaultValue)
        {
            return ToDateTime(sqlDataReader, ordinal, defaultValue, false);
        }

        public static DateTime ToDateTime(SqlDataReader sqlDataReader, string columnName, DateTime defaultValue)
        {
            return ToDateTime(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static DateTime ToDateTime(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToDateTime(sqlDataReader, ordinal, DateTime.MinValue, true);
        }

        public static DateTime ToDateTime(SqlDataReader sqlDataReader, string columnName)
        {
            return ToDateTime(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        public static Guid ToGuid(SqlDataReader sqlDataReader, int ordinal, Guid defaultValue, bool throwExceptionOnNull)
        {
            if ((ordinal >= 0) && !sqlDataReader.IsDBNull(ordinal))
            {
                return sqlDataReader.GetGuid(ordinal);
            }
            if (throwExceptionOnNull)
                throw new NullReferenceException(nullParameterMessage);
            return defaultValue;
        }

        public static Guid ToGuid(SqlDataReader sqlDataReader, int ordinal, Guid defaultValue)
        {
            return ToGuid(sqlDataReader, ordinal, defaultValue, false);
        }

        public static Guid ToGuid(SqlDataReader sqlDataReader, string columnName, Guid defaultValue)
        {
            return ToGuid(sqlDataReader, sqlDataReader.GetOrdinal(columnName), defaultValue, false);
        }

        public static Guid ToGuid(SqlDataReader sqlDataReader, int ordinal)
        {
            return ToGuid(sqlDataReader, ordinal, Guid.Empty, true);
        }

        public static Guid ToGuid(SqlDataReader sqlDataReader, string columnName)
        {
            return ToGuid(sqlDataReader, sqlDataReader.GetOrdinal(columnName));
        }

        #endregion
    }

    public abstract class SqlPersisterBase
    {
        private readonly List<SqlCommand> autoCloseCommands = new List<SqlCommand>();
        private SqlConnection connection;
        private string connectionString;
        private SqlTransaction transaction;

        protected SqlPersisterBase()
        {
        }

        protected SqlPersisterBase(string connectionString)
        {
            this.connectionString = connectionString;
        }

        protected SqlPersisterBase(SqlConnection connection)
        {
            this.connection = connection;
        }

        protected SqlPersisterBase(SqlTransaction transaction)
        {
            connection = transaction.Connection;
            this.transaction = transaction;
        }

        public string ConnectionString
        {
            get { return connectionString; }
            set { connectionString = value; }
        }

        public SqlConnection Connection
        {
            get { return connection; }
            set { connection = value; }
        }

        public SqlTransaction Transaction
        {
            get { return transaction; }
            set { transaction = value; }
        }

        protected void AttachCommand(SqlCommand command)
        {
            // Ensure connection has been provided
            EnsureConnection();

            if (connection != null)
            {
                command.CommandTimeout = 1000000000;
                command.Connection = connection;
                if (transaction != null)
                {
                    command.Transaction = transaction;
                }
            }
            else
            {
                command.Connection = new SqlConnection(connectionString);
                command.Connection.Open();
                lock (autoCloseCommands)
                {
                    autoCloseCommands.Add(command);
                }
            }
        }

        protected CommandBehavior AttachReaderCommand(SqlCommand command)
        {
            // Ensure connection has been provided
            EnsureConnection();

            if (connection != null)
            {
                command.Connection = connection;
                if (transaction != null)
                {
                    command.Transaction = transaction;
                }
                return CommandBehavior.Default;
            }
            command.Connection = new SqlConnection(connectionString);
            command.Connection.Open();
            return CommandBehavior.CloseConnection;
        }

        protected void DetachCommand(SqlCommand command)
        {
            lock (autoCloseCommands)
            {
                if (autoCloseCommands.Contains(command))
                {
                    command.Connection.Close();
                    command.Connection.Dispose();
                    command.Connection = null;
                    autoCloseCommands.Remove(command);
                }
                else
                {
                    command.Transaction = null;
                    command.Connection = null;
                }
            }
        }

        private void EnsureConnection()
        {
            if ((connectionString != null) || (connection != null))
            {
            }
            else
            {
                if (SqlServerHelper.Connection != null)
                {
                    connection = SqlServerHelper.Connection;
                    if (SqlServerHelper.Transaction != null)
                    {
                        transaction = SqlServerHelper.Transaction;
                    }
                }
                else if (SqlServerHelper.ConnectionString != null)
                {
                    connectionString = SqlServerHelper.ConnectionString;
                }
                else
                {
                    // Throw exception, nothing to connect
                    throw new DataException("No connection string or connection has been provided.");
                }
            }
        }
    }
}