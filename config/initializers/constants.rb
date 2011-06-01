# it's very important that these stay in the same order as dafts county list
COUNTIES = %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down].freeze

# These should all be converted to in memory classes
LENDERS = ['Bank of Ireland', 'AIB', 'Ulster Bank'].freeze
LENDER_UIDS = ['BOI', 'AIB', "UB"].freeze

LOAN_TYPES = ['Variable Rate', "1 Year Fixed Rate", "2 Year Fixed Rate", "3 Year Fixed Rate", "4 Year Fixed Rate",
              "5 Year Fixed Rate", "6 Year Fixed Rate"].freeze
LOAN_TYPE_UIDS = ['VR', 'PFR1', 'PFR2', 'PFR3', 'PFR4', 'PFR5', 'PFR6'].freeze

BATHROOMS = [1,2,3,4,5].freeze
BEDROOMS = [1,2,3,4,5].freeze