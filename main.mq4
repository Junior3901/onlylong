//+------------------------------------------------------------------+
//|                                                       test-2.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// define input parameters
extern double lotsize = 1;
extern int stoploss = 50;
extern int takeprofit = 100;
extern double sar_step = 0.02;
extern double sar_maximum = 0.2;
extern double adx_threshold = 30;

// define variables
int buy_order;
int sell_order;

void OnTick()
{
    double ema8 = iMA(NULL, 0, 8, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema14 = iMA(NULL, 0, 14, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema21 = iMA(NULL, 0, 21, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema50 = iMA(NULL, 0, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema100 = iMA(NULL, 0, 100, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema200 = iMA(NULL, 0, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
    double adx = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 0);
    double di_minus = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, 0);
    double di_plus = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, 0);
    double sar = iSAR(NULL, 0, sar_step, sar_maximum, 0);

    // check for buy conditions
    if (ema8 > ema14 && ema14 > ema21 && ema21 > ema50 && ema50 > ema100 && ema100 > ema200 && adx > adx_threshold && di_minus < adx_threshold && Bid > sar)
    {
        // check if there is no existing buy order
        if (buy_order == 0)
        {
            // open buy order
            Alert("BUY LONG HAPPENED");
            buy_order = OrderSend(Symbol(), OP_BUY, lotsize, Ask, 0, NormalizeDouble(Bid - stoploss * Point, Digits), NormalizeDouble(Bid + takeprofit * Point, Digits), "Buy", 0, 0, Blue);
        }
    }
    else
    {
        // check if there is an existing buy order
        if (buy_order != 0)
        {
            // close buy order
            Alert("SELL LONG HAPPENED");
            OrderClose(buy_order, lotsize, Bid, 0, Green);
            buy_order = 0;
        }
    }
    
}
