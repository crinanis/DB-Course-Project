use Oishi;
GO

CREATE OR ALTER VIEW VORDERS
	AS
		SELECT OrderID[Order ID], UserOID[User ID], BookingDatetime[Booking time], TableOID[Table ID], Wishes 
			FROM ORDERS
				WHERE OrderStatus = 0
				GROUP BY OrderID, UserOID, BookingDatetime, TableOID, Wishes;
	