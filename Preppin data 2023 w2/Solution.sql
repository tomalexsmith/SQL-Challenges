select t.transaction_id, country_code||check_digits||swift_code||sort||ACCOUNT_NUMBER as IBAN
from (
    select t.*,replace(sort_code,'-') as sort, check_digits,swift_code, 'GB' as country_code
    from pd2023_wk02_transactions t
    left join pd2023_wk02_swift_codes s
    on t.bank = s.bank
) t
