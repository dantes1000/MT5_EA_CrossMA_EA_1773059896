// CrossMA_EA.mq5 - Expert Advisor basé sur croisement de moyennes mobiles

// Inclusions des fichiers .mqh
#include "RiskManager.mqh"
#include "Indicators.mqh"
#include "TradingFunctions.mqh"
#include "SignalGenerator.mqh"

// Variables globales
bool IndicatorsInitialized = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialisation des indicateurs
    IndicatorsInitialized = InitializeIndicators();
    
    if(!IndicatorsInitialized)
    {
        Print("Échec de l'initialisation des indicateurs");
        return INIT_FAILED;
    }
    
    Print("CrossMA_EA initialisé avec succès");
    Print("Paramètres : MA Rapide=", FastMAPeriod, ", MA Lente=", SlowMAPeriod);
    Print("Stop Loss=", StopLossPips, " pips, Take Profit=", TakeProfitPips, " pips");
    Print("Lot fixe=", FixedLot);
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Nettoyage des indicateurs
    CleanupIndicators();
    
    Print("CrossMA_EA désinitialisé");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Vérifier si les indicateurs sont initialisés
    if(!IndicatorsInitialized)
        return;
    
    // Générer le signal
    ENUM_SIGNAL signal = GenerateSignal();
    
    // Si aucun signal ou position déjà ouverte, ne rien faire
    if(signal == SIGNAL_NONE || HasOpenPosition())
        return;
    
    // Exécuter le trade selon le signal
    bool tradeResult = false;
    
    switch(signal)
    {
        case SIGNAL_BUY:
            tradeResult = OpenBuyPosition();
            break;
            
        case SIGNAL_SELL:
            tradeResult = OpenSellPosition();
            break;
    }
    
    if(tradeResult)
    {
        Print("Trade exécuté avec succès pour le signal : ", EnumToString(signal));
    }
}

//+------------------------------------------------------------------+
//| Fonction pour tester l'EA (utilisée dans le Strategy Tester)     |
//+------------------------------------------------------------------+
void OnTester()
{
    // Cette fonction est appelée à la fin des tests dans le Strategy Tester
    Print("Test terminé pour CrossMA_EA");
}

//+------------------------------------------------------------------+
//| Fonction pour gérer les événements de trading                    |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Cette fonction est appelée lorsqu'un événement de trading se produit
    // Peut être utilisée pour le logging ou d'autres actions
}

//+------------------------------------------------------------------+