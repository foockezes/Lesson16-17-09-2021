using System;
using System.Data.SqlClient;

namespace ConsoleApp
{
    class Newaccount
    {
        public string Account { get; set; }
        public int Is_Active { get; set; }
        public DateTime Created_At { get; set; }
        public DateTime? Updated_At { get; set; }
    }
    class Transactions
    {
        public decimal amount { get; set; }
        public DateTime Created_At { get; set; }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            string ConString = "" + @"Data source=.\SQLEXPRESS; " + "Initial catalog=Person; " + "Trusted_Connection = True;";
            while (true)
            {
                Console.Write("1. Creat Account:\n2. Show Account:\n3. Transfer:\nyour Chice? ");
                int choice = Convert.ToInt32(Console.ReadLine());
                switch (choice)
                {
                    case 1:
                        {
                            CreateAccount(ConString);
                        }
                        break;
                    case 2:
                        {
                            ShowAcconts(ConString);
                        }
                        break;
                    case 3:
                        {
                            Console.Write("From account: ");
                            var fromAcc = Console.ReadLine();
                            Console.Write("To account: ");
                            var toAcc = Console.ReadLine();
                            Console.Write("Amount: ");
                            decimal.TryParse(Console.ReadLine(), out var amount);

                            Transfer(fromAcc, toAcc, amount, ConString);
                        }
                        break;
                }
                Console.WriteLine("Press enter...");
                Console.ReadLine();
                Console.Clear();
            }
        }
        private static void CreateAccount(string conString)
        {
            Console.WriteLine("Type new account Number -For example- '22141'");
            var Newaccount = new Newaccount() 
            { 
                Account = Console.ReadLine(),
                Created_At = DateTime.Now, 
            };
            var conn = new SqlConnection(conString);
            var query = "INSERT INTO Account ([Account],[Created_At]) VALUES(@account, @created_At)";
            var command = conn.CreateCommand();
            command.CommandText = query;
            command.Parameters.AddWithValue("@account", Newaccount.Account);
            command.Parameters.AddWithValue("@created_At", Newaccount.Created_At);
            conn.Open();
            var result = command.ExecuteNonQuery();
            if (result > 0) Console.WriteLine("Added successfully");
            conn.Close();
        }
        private static void ShowAcconts(string conString)
        {
            var conn = new SqlConnection(conString);
            conn.Open();
            var query = "SELECT * FROM Account;";
            var command = conn.CreateCommand();
            command.CommandText = query;
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine($"Account: {reader.GetValue(1)}");
            }
            reader.Close();
            conn.Close();
        }
        private static decimal GetAccountBalance(string ConString, string Account)
        {
            var conn = new SqlConnection(ConString);
            conn.Open();
            var command = conn.CreateCommand();
            command.CommandText = "Select Amount From Transactions WHERE Id = @fromAcc;";
            command.Parameters.AddWithValue("@fromAcc", Account);
            var reader = command.ExecuteReader();
            var fromAccBalance = 0m;
            while (reader.Read())
            {
                fromAccBalance = !string.IsNullOrEmpty(reader.GetValue(0)?.ToString()) ? reader.GetDecimal(0) : 0;
            }
            reader.Close();
            command.Parameters.Clear();
            conn.Close();
            return fromAccBalance;
        }

        private static int GetAccountId(string Account, string ConString)
        {
            var AccNumber = 0;
            var conn = new SqlConnection(ConString);
            conn.Open();
            var query = "SELECT [Id] FROM Account WHERE [Account] = @Account;";
            var command = conn.CreateCommand();
            command.Parameters.AddWithValue("@Account", Account);
            command.CommandText = query;

            var reader = command.ExecuteReader();
            while (reader.Read()) AccNumber = reader.GetInt32(0);
            conn.Close();
            reader.Close();
            return AccNumber;
        }
        
        private static void Transfer(string fromAcc, string toAcc, decimal amount, string conString)
        {
            if (string.IsNullOrEmpty(fromAcc) || string.IsNullOrEmpty(toAcc) || amount == 0)
            {
                Console.WriteLine("Someting is wrong");
                return;
            }
            var conn = new SqlConnection(conString);
            conn.Open();
            if (!(conn.State == System.Data.ConnectionState.Open))
            {
                return;
            }
            SqlTransaction transaction = conn.BeginTransaction();
            var command = conn.CreateCommand();
            command.Transaction = transaction;
            try
            {
                var FromAccBalance = GetAccountBalance(conString, fromAcc);
                if (FromAccBalance <= 0 || (FromAccBalance - amount) < 0)
                {
                    throw new Exception("Not enough money");
                }
                var FromAccId = GetAccountId(fromAcc, conString);
                if (FromAccId == 0) throw new Exception("account not found");
                command.CommandText = "Update Transactions SET Amount = Amount - @amount WHERE Account_Id = @Account_Id;";
                command.Parameters.AddWithValue("@Amount", amount);
                command.Parameters.AddWithValue("@Account_Id", FromAccId);
                var result1 = command.ExecuteNonQuery();

                var toAccId = GetAccountId(toAcc, conString);

                if (toAccId == 0) throw new Exception("Account not found");

                command.Parameters.Clear();
                command.CommandText = "Update Transactions SET Amount = Amount + @amount WHERE Account_Id = @Account_Id;";
                command.Parameters.AddWithValue("@Amount", amount);
                command.Parameters.AddWithValue("@Account_Id", toAccId);
                var result2 = command.ExecuteNonQuery();

                if (result1 == 0 || result2 == 0) throw new Exception("Something went wrong");

                transaction.Commit();
                if (conn.State == System.Data.ConnectionState.Open) Console.WriteLine("succsess");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                transaction.Rollback();
            }
            finally
            {
                conn.Close();
            }

        }
    }
}