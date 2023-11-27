# GET
```
10.0.0.3:5000/ledger
```

# POST
```
10.0.0.3:5000/ledger
{
    "date": "2023-04-10",
    "amount": 300
}
```

# PATCH
```
10.0.0.3:5000/ledger?id=eq.49
{
    "amount": 500
}
```

# DELETE
```
10.0.0.3:5000/ledger?id=eq.51
```

# GET Overview Function
```
10.0.0.3:5000/rpc/get_ledger_overview?account_id_arg=1
```
