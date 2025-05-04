import 'package:bonjour/Modul/Home/dashboard_controller.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Map<String, double> weeklySales = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  late List<String> dayOrder;
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    final dashboardCtrl = Provider.of<DashboardController>(context, listen: false);
    dashboardCtrl.fetchData().then((_) {
      setState(() {
        weeklySales = dashboardCtrl.data ?? weeklySales;
      });
    });

    
    dayOrder = getDayOrder();
  }

  double getMaxY() {
    double maxValue = weeklySales.values.fold(0, (prev, element) => element > prev ? element : prev);
    double bufferValue = maxValue * 1.1;  // Add 10% buffer
    return ((bufferValue + 9) ~/ 10) * 10;  // Round up to nearest 10
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      // adUnitId: 'ca-app-pub-2333701761148479/2245429545', // Test Banner Ad Unit ID
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Banner Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
            print('Banner Ad loaded successfully');
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  List<String> getDayOrder() {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int todayIndex = DateTime.now().weekday % 7; 

    return [
      ...days.sublist(todayIndex),
      ...days.sublist(0, todayIndex),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loginCtrl = Provider.of<LoginController>(context, listen: false);
    List<BarChartGroupData> salesData = List.generate(dayOrder.length, (index) {
      String day = dayOrder[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklySales[day] ?? 0,
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.dashboard),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "📈 Sales Summary (Last 7 Days)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.all(5.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 15, 10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      formatValue(value),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < dayOrder.length) {
                                      return Text(
                                        dayOrder[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      );
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.blueAccent, width: 2),
                            ),
                            barGroups: salesData,
                            maxY: getMaxY(),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(),
                              handleBuiltInTouches: true,
                            ),
                            alignment: BarChartAlignment.spaceAround,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isBannerAdLoaded && !loginCtrl.user.module!.contains("PREMIUM"))
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                child: AdWidget(ad: _bannerAd),
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
              ),
            ),
        ],
      ),
    );
  }

  
  String formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)} Jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
