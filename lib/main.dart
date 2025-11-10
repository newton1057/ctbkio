// KIOSKO DEMO – v4.0 VISUAL DESIGN UPGRADE
// Cambios v4.0:
// - Rediseño completo de la UI para un look moderno y atractivo para terminales públicas.
// - Nueva paleta de colores (azules y púrpuras) y fondo con gradiente.
// - Tema global mejorado: botones, inputs y tarjetas estilizadas.
// - Rediseño de tarjetas de categoría en la Home con gradientes.
// - Rediseño de tarjetas de producto con superposición de imagen y mejor legibilidad.
// - Mejora visual en la página del carrito, reintroduciendo la imagen del producto.
// - Pantallas de checkout y pago con un diseño más limpio y profesional.
// - Pantallas de simulación de pago más inmersivas y claras.
// --------------------------------------------------------------------

import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = KioState();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A90E2);
    const secondaryColor = Color(0xFF50E3C2);
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: const Color(0xFFF4F7FC),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.transparent, // Para permitir el gradiente
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: Brightness.light).textTheme,
      ).copyWith(
        displayLarge: const TextStyle(fontWeight: FontWeight.w800),
        displayMedium: const TextStyle(fontWeight: FontWeight.w800),
        displaySmall: const TextStyle(fontWeight: FontWeight.w800),
        headlineMedium: const TextStyle(fontWeight: FontWeight.w800),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: const Color(0xFF4A90E2).withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );

    return KioScope(
      state: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kiosko Demo',
        theme: base,
        home: const LibraryHome(),
      ),
    );
  }
}

/// Widget para el fondo degradado de la aplicación
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFF4F7FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------
// GLOBAL APP STATE (sin cambios)
// ---------------------------------------------------------------
class KioState extends ChangeNotifier {
  Language _lang = Language.es; // default to ES for demo
  Language get lang => _lang;
  set lang(Language v) {
    if (_lang != v) {
      _lang = v;
      notifyListeners();
    }
  }

  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  void addToCart(Product p, {int qty = 1}) {
    final idx = _cart.indexWhere((e) => e.product.id == p.id);
    if (idx >= 0) {
      _cart[idx] = _cart[idx].copyWith(qty: _cart[idx].qty + qty);
    } else {
      _cart.add(CartItem(product: p, qty: qty));
    }
    notifyListeners();
  }

  void setQty(String productId, int qty) {
    final idx = _cart.indexWhere((e) => e.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        _cart.removeAt(idx);
      } else {
        _cart[idx] = _cart[idx].copyWith(qty: qty);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get totalUSD =>
      _cart.fold(0.0, (s, e) => s + e.product.priceUsd * e.qty);
}

class KioScope extends InheritedNotifier<KioState> {
  const KioScope({super.key, required super.child, required KioState state})
      : super(notifier: state);

  static KioState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KioScope>();
    assert(scope != null, 'KioScope not found in context');
    return scope!.notifier!;
  }
}

enum Language { en, es }

String t(BuildContext context, String en, String es) {
  final lang = KioScope.of(context).lang;
  return lang == Language.en ? en : es;
}

// ---------------------------------------------------------------
// MODELS & DUMMY DATA (sin cambios)
// ---------------------------------------------------------------
class Product {
  final String id;
  final String titleEn;
  final String titleEs;
  final String descEn;
  final String descEs;
  final double priceUsd;
  final String imageUrl;
  final KioCategory category;
  final List<String> emojis; // quick visual tags

  const Product({
    required this.id,
    required this.titleEn,
    required this.titleEs,
    required this.descEn,
    required this.descEs,
    required this.priceUsd,
    required this.imageUrl,
    required this.category,
    this.emojis = const [],
  });

  String title(Language lang) => lang == Language.en ? titleEn : titleEs;
  String desc(Language lang) => lang == Language.en ? descEn : descEs;
}

class CartItem {
  final Product product;
  final int qty;
  const CartItem({required this.product, this.qty = 1});
  CartItem copyWith({Product? product, int? qty}) =>
      CartItem(product: product ?? this.product, qty: qty ?? this.qty);
}

enum KioCategory { conecta, vive, institucional, impulsa }

String categoryName(KioCategory c, Language lang) {
  switch (c) {
    case KioCategory.conecta:
      return lang == Language.en ? 'Connect' : 'Conecta';
    case KioCategory.vive:
      return lang == Language.en ? 'Live' : 'Vive';
    case KioCategory.institucional:
      return lang == Language.en ? 'Institutional' : 'Institucional';
    case KioCategory.impulsa:
      return lang == Language.en ? 'Boost' : 'Impulsa';
  }
}

String picsum(String seed, {int w = 800, int h = 600}) =>
    'https://picsum.photos/seed/$seed/$w/$h';

final products = <Product>[
  // --- VIVE (Airport-friendly experiences/amenities) ---
  Product(
    id: 'lounge_daypass',
    titleEn: 'Airport Lounge Day Pass (CUN)',
    titleEs: 'Pase Diario a Sala VIP (CUN)',
    priceUsd: 39,
    imageUrl: picsum('lounge_daypass'), // Usa el ID como seed
    category: KioCategory.vive,
    emojis: ['🛋️', '🧖', '🫖'],
    descEn:
        'Access a premium lounge at Cancún Airport (showers on select lounges). Snacks, drinks and Wi‑Fi before your flight.',
    descEs:
        'Acceso a sala VIP en el Aeropuerto de Cancún (algunas con regaderas). Snacks, bebidas y Wi‑Fi antes de tu vuelo.',
  ),
  Product(
    id: 'spa_express',
    titleEn: 'Express Spa 15 min (Neck/Back)',
    titleEs: 'Spa Express 15 min (Cuello/Espalda)',
    priceUsd: 19,
    imageUrl: picsum('spa_express'),
    category: KioCategory.vive,
    emojis: ['💆', '⏱️', '🧴'],
    descEn:
        'Quick relaxation service inside the terminal: 15‑minute massage to recharge before boarding.',
    descEs:
        'Relajación rápida dentro de la terminal: masaje de 15 minutos para recargar antes de abordar.',
  ),
  Product(
    id: 'kids_pack',
    titleEn: 'Family & Kids Travel Pack',
    titleEs: 'Paquete Familiar para Viaje',
    priceUsd: 14,
    imageUrl: picsum('kids_pack'),
    category: KioCategory.vive,
    emojis: ['🧸', '🎒', '🍭'],
    descEn:
        'Entertainment kit for kids (coloring booklet, mini snacks, wipes). Perfect for long flights.',
    descEs:
        'Kit de entretenimiento para peques (libreta para colorear, minisnacks, toallitas). Ideal para vuelos largos.',
  ),
  Product(
    id: 'food_combo',
    titleEn: 'Warm Meal Combo Voucher',
    titleEs: 'Vale de Comida Caliente',
    priceUsd: 16,
    imageUrl: picsum('food_combo'),
    category: KioCategory.vive,
    emojis: ['🍔', '🥤', '🧾'],
    descEn:
        'Redeemable in selected food courts: warm dish + soft drink. Easy and fast at peak hours.',
    descEs:
        'Canjeable en zonas de comida participantes: plato caliente + bebida. Rápido en horas pico.',
  ),
  Product(
    id: 'dutyfree_gift',
    titleEn: 'Duty‑Free Gift Card (Digital)',
    titleEs: 'Tarjeta de Regalo Duty‑Free (Digital)',
    priceUsd: 30,
    imageUrl: picsum('dutyfree_gift'),
    category: KioCategory.vive,
    emojis: ['🎁', '🛍️', '✈️'],
    descEn:
        'Digital balance to use at participating duty‑free stores inside Cancún Airport.',
    descEs:
        'Saldo digital para usar en tiendas duty‑free participantes dentro del Aeropuerto de Cancún.',
  ),
  Product(
    id: 'travel_kit',
    titleEn: 'Travel Pillow & Blanket Set',
    titleEs: 'Set Almohada de Viaje + Cobija',
    priceUsd: 22,
    imageUrl: picsum('travel_kit'),
    category: KioCategory.vive,
    emojis: ['🛌', '🧣', '🧼'],
    descEn:
        'Comfort set for your flight: neck pillow, soft blanket, and hygiene kit.',
    descEs:
        'Set de confort para tu vuelo: almohada cervical, cobija suave y kit de higiene.',
  ),

  // --- CONECTA (Mobility, connectivity, essentials at airport) ---
  Product(
    id: 'fasttrack_airport',
    titleEn: 'Airport Fast Track (CUN)',
    titleEs: 'Fast Track Aeropuerto (CUN)',
    priceUsd: 35,
    imageUrl: picsum('fasttrack_airport'),
    category: KioCategory.conecta,
    emojis: ['✈️', '⚡', '🛄'],
    descEn:
        'Skip the lines with meet & assist at arrivals or departures. Perfect for tight schedules.',
    descEs:
        'Evita filas con meet & assist en llegada o salida. Ideal para itinerarios ajustados.',
  ),
  Product(
    id: 'sim_tourist',
    titleEn: 'Tourist eSIM / SIM (5–10 GB)',
    titleEs: 'eSIM / SIM Turista (5–10 GB)',
    priceUsd: 25,
    imageUrl: picsum('sim_tourist'),
    category: KioCategory.conecta,
    emojis: ['📶', '🌐', '📱'],
    descEn:
        'Stay connected from day one. Quick activation, airport pickup or QR activation.',
    descEs:
        'Conéctate desde el día uno. Activación rápida, recolección en aeropuerto o por QR.',
  ),
  Product(
    id: 'baggage_wrap',
    titleEn: 'Baggage Wrapping Service',
    titleEs: 'Envoltura de Equipaje',
    priceUsd: 12,
    imageUrl: picsum('baggage_wrap'),
    category: KioCategory.conecta,
    emojis: ['🎁', '🛄', '🔒'],
    descEn:
        'Protect your suitcase with airport plastic wrapping. Ideal for connections and long trips.',
    descEs:
        'Protege tu maleta con envoltura plástica en el aeropuerto. Ideal para conexiones y viajes largos.',
  ),
  Product(
    id: 'luggage_storage',
    titleEn: 'Luggage Storage (Per Piece / Day)',
    titleEs: 'Guardaequipaje (Por Pieza / Día)',
    priceUsd: 9,
    imageUrl: picsum('luggage_storage'),
    category: KioCategory.conecta,
    emojis: ['🧳', '🕒', '🔐'],
    descEn:
        'Leave your bags safely while you visit Cancún between flights. Day rate per item.',
    descEs:
        'Deja tus maletas en resguardo mientras visitas Cancún entre vuelos. Tarifa por día y por pieza.',
  ),
  Product(
    id: 'currency_voucher',
    titleEn: 'Currency Exchange Voucher',
    titleEs: 'Cupón de Casa de Cambio',
    priceUsd: 5,
    imageUrl: picsum('currency_voucher'),
    category: KioCategory.conecta,
    emojis: ['💱', '💵', '🧾'],
    descEn:
        'Digital voucher for preferred rate at participating exchange counters inside CUN.',
    descEs:
        'Cupón digital para tipo preferente en casas de cambio participantes dentro de CUN.',
  ),
  Product(
    id: 'car_rental',
    titleEn: 'Car Rental Desk Reservation',
    titleEs: 'Reserva en Módulo de Renta de Autos',
    priceUsd: 20,
    imageUrl: picsum('car_rental'),
    category: KioCategory.conecta,
    emojis: ['🚗', '🛣️', '🔑'],
    descEn:
        'Priority reservation token for on‑site car rental desks. Pick up right after landing.',
    descEs:
        'Token de reserva prioritaria para módulos de renta de autos. Recoge al aterrizar.',
  ),
  Product(
    id: 'parking_prebook',
    titleEn: 'Airport Parking Pre‑Booking',
    titleEs: 'Pre‑Reserva de Estacionamiento Aeroportuario',
    priceUsd: 8,
    imageUrl: picsum('parking_prebook'),
    category: KioCategory.conecta,
    emojis: ['🅿️', '🚘', '🕒'],
    descEn:
        'Reserve your parking slot near your terminal with flexible entry time.',
    descEs:
        'Reserva tu lugar de estacionamiento cerca de tu terminal con horario flexible.',
  ),

  // --- INSTITUCIONAL (Airport authority / assistance) ---
  Product(
    id: 'medical_point',
    titleEn: 'Airport Medical Point – Basic Assistance',
    titleEs: 'Punto Médico del Aeropuerto – Asistencia Básica',
    priceUsd: 15,
    imageUrl: picsum('medical_point'),
    category: KioCategory.institucional,
    emojis: ['🏥', '🩺', '⛑️'],
    descEn:
        'First‑aid and basic check in coordination with airport medical services. Non‑emergency.',
    descEs:
        'Primeros auxilios y chequeo básico en coordinación con servicios médicos del aeropuerto. No emergencia.',
  ),
  Product(
    id: 'lost_found_assist',
    titleEn: 'Lost & Found Assistance (Guide)',
    titleEs: 'Asistencia de Objetos Perdidos (Guía)',
    priceUsd: 0,
    imageUrl: picsum('lost_found_assist'),
    category: KioCategory.institucional,
    emojis: ['🔎', '🧳', '📄'],
    descEn:
        'Step‑by‑step assistance to file reports for lost items with airport and airline desks.',
    descEs:
        'Acompañamiento paso a paso para levantar reporte de objetos perdidos con aeropuerto y aerolínea.',
  ),
  Product(
    id: 'mobility_assist',
    titleEn: 'Mobility & Wheelchair Request',
    titleEs: 'Solicitud de Movilidad y Silla de Ruedas',
    priceUsd: 0,
    imageUrl: picsum('mobility_assist'),
    category: KioCategory.institucional,
    emojis: ['♿', '🧑‍🦽', '🛫'],
    descEn:
        'Assistance coordination for passengers with reduced mobility (PRM) through terminals.',
    descEs:
        'Coordinación de asistencia para pasajeros con movilidad reducida (PRM) en terminales.',
  ),
  Product(
    id: 'pet_relief',
    titleEn: 'Pet Relief & Travel Kit',
    titleEs: 'Zona para Mascotas + Kit de Viaje',
    priceUsd: 10,
    imageUrl: picsum('pet_relief'),
    category: KioCategory.institucional,
    emojis: ['🐶', '🧻', '🦴'],
    descEn:
        'Guidance to pet‑relief areas and a small kit (waste bags, wipes).',
    descEs:
        'Guía a áreas para mascotas y pequeño kit (bolsas, toallitas).',
  ),

  // --- IMPULSA (Business & corporate services at airport) ---
  Product(
    id: 'vip_meet_greet',
    titleEn: 'VIP Meet & Greet – Corporate',
    titleEs: 'Meet & Greet VIP – Corporativo',
    priceUsd: 65,
    imageUrl: picsum('vip_meet_greet'),
    category: KioCategory.impulsa,
    emojis: ['🤝', '🕴️', '⚡'],
    descEn:
        'Personalized reception at arrival with escort through procedures. Ideal for executives and groups.',
    descEs:
        'Recepción personalizada a la llegada con acompañamiento en trámites. Ideal para ejecutivos y grupos.',
  ),
  Product(
    id: 'cowork_pod',
    titleEn: 'Coworking Pod – 30 min',
    titleEs: 'Cabina de Cowork – 30 min',
    priceUsd: 12,
    imageUrl: picsum('cowork_pod'),
    category: KioCategory.impulsa,
    emojis: ['💻', '🔇', '🔌'],
    descEn:
        'Sound‑dampened booth with desk, power outlets and fast Wi‑Fi. Perfect for quick calls.',
    descEs:
        'Cabina con aislamiento, escritorio, tomas de corriente y Wi‑Fi rápido. Ideal para llamadas breves.',
  ),
  Product(
    id: 'meeting_room',
    titleEn: 'Meeting Room – 1 hour',
    titleEs: 'Sala de Juntas – 1 hora',
    priceUsd: 29,
    imageUrl: picsum('meeting_room'),
    category: KioCategory.impulsa,
    emojis: ['🏢', '🗂️', '🖥️'],
    descEn:
        'Small meeting room near lounges. Includes screen and HDMI on request.',
    descEs:
        'Sala de juntas cercana a salas VIP. Incluye pantalla y HDMI a solicitud.',
  ),
  Product(
    id: 'print_scan',
    titleEn: 'Print & Scan Service (10 pages)',
    titleEs: 'Impresión y Escaneo (10 páginas)',
    priceUsd: 7,
    imageUrl: picsum('print_scan'),
    category: KioCategory.impulsa,
    emojis: ['🖨️', '📄', '📧'],
    descEn:
        'Quick printing/scanning with email upload. Add pages at a low extra cost.',
    descEs:
        'Impresión/escaneo rápido con carga por correo. Agrega páginas con costo extra bajo.',
  ),
  Product(
    id: 'corp_transfer',
    titleEn: 'Corporate Transfer – Hotel Zone',
    titleEs: 'Traslado Corporativo – Zona Hotelera',
    priceUsd: 35,
    imageUrl: picsum('corp_transfer'),
    category: KioCategory.impulsa,
    emojis: ['🚘', '🕴️', '🛎️'],
    descEn:
        'Executive car with driver. Meet at arrivals, bottled water included.',
    descEs:
        'Auto ejecutivo con chofer. Encuentro en llegadas, incluye agua embotellada.',
  ),
  Product(
    id: 'corp_invoicing',
    titleEn: 'On‑Site e‑Invoicing (CFDI) Assist',
    titleEs: 'Asistencia de Facturación Electrónica en Sitio (CFDI)',
    priceUsd: 5,
    imageUrl: picsum('corp_invoicing'),
    category: KioCategory.impulsa,
    emojis: ['🧾', '💼', '⚙️'],
    descEn:
        'Help generating a compliant e‑invoice for your airport purchases. Receive it by email.',
    descEs:
        'Ayuda para generar factura electrónica conforme por tus compras en el aeropuerto. Recíbela por correo.',
  ),
];

// ---------------------------------------------------------------
// HOME
// ---------------------------------------------------------------
class LibraryHome extends StatelessWidget {
  const LibraryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Feature>[
      _Feature('Conecta', const Color(0xFF4A90E2), const Color(0xFF2C578A), Icons.hub, KioCategory.conecta),
      _Feature('Vive', const Color(0xFF50E3C2), const Color(0xFF2A8C74), Icons.beach_access, KioCategory.vive),
      _Feature('Institucional', const Color(0xFFF5A623), const Color(0xFFB0781A),Icons.account_balance, KioCategory.institucional),
      _Feature('Impulsa', const Color(0xFFBD10E0), const Color(0xFF790A93), Icons.rocket_launch, KioCategory.impulsa),
    ];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _LangPill(),
                        const _CartButton(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Text(
                            t(context, 'Welcome to your Digital Kiosk!', '¡Bienvenido a tu Kiosko Digital!'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: const Color(0xFF1D2939),),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            t(context, 'What would you like to explore today?', '¿Qué te gustaría explorar hoy?'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: const Color(0xFF475467),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Search
                    const _SearchBar(),
                    const SizedBox(height: 32),
                    // Grid 2x2
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, i) {
                          final f = items[i];
                          return _FeatureCard(
                            title: f.title,
                            gradient: LinearGradient(
                              colors: [f.colorStart, f.colorEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            icon: f.icon,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CatalogPage(category: f.category),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// SEARCH
// ---------------------------------------------------------------
class _SearchBar extends StatefulWidget {
  const _SearchBar();
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: ctrl,
        onSubmitted: (txt) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  CatalogPage(query: txt.trim().isEmpty ? null : txt.trim()),
            ),
          );
        },
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: t(
            context,
            'Search experiences, services, tours…',
            'Busca experiencias, servicios, tours…',
          ),
          hintStyle: const TextStyle(color: Color(0xFF667085)),
          prefixIcon:
              Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// CATALOG PAGE
// ---------------------------------------------------------------
class CatalogPage extends StatefulWidget {
  final KioCategory? category;
  final String? query;
  const CatalogPage({super.key, this.category, this.query});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String? _query;
  KioCategory? _category;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;

    List<Product> list = products;
    if (_category != null) {
      list = list.where((p) => p.category == _category).toList();
    }
    if ((_query ?? '').isNotEmpty) {
      final q = _query!.toLowerCase();
      list = list
          .where(
            (p) =>
                p.title(lang).toLowerCase().contains(q) ||
                p.desc(lang).toLowerCase().contains(q),
          )
          .toList();
    }

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            // Custom App Bar
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    BackButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        iconColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _category == null
                            ? t(context, 'All Services', 'Todos los Servicios')
                            : categoryName(_category!, lang),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const _CartButton(),
                  ],
                ),
              ),
            ),
            _Filters(
              active: _category,
              onTap: (c) => setState(() => _category = c),
            ),
            Expanded(
              child: list.isEmpty 
              ? Center(child: Text(t(context, 'No results found', 'No se encontraron resultados')))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _ProductListCard(product: list[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductListCard extends StatelessWidget {
  final Product product;
  const _ProductListCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      borderRadius: BorderRadius.circular(24),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with overlay
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const _ImageSkeleton();
                      },
                      errorBuilder: (context, error, stack) {
                        return const _ImageError();
                      },
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                    // Price Tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${product.priceUsd.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.desc(lang),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF475467), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: -4,
                    children: [
                      for (final e in product.emojis)
                        Text(e, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary)),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Center(
          child:
              Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey)),
    );
  }
}

class _Filters extends StatelessWidget {
  final KioCategory? active;
  final ValueChanged<KioCategory?> onTap;
  const _Filters({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;
    final cats = KioCategory.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: t(context, 'All', 'Todo'),
            selected: active == null,
            onTap: () => onTap(null),
          ),
          const SizedBox(width: 10),
          for (final c in cats) ...[
            _FilterChip(
              label: categoryName(c, lang),
              selected: active == c,
              onTap: () => onTap(c),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// PRODUCT DETAIL + BOOKING SHEET
// ---------------------------------------------------------------
class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    final lang = state.lang;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              backgroundColor: const Color(0xFFF4F7FC),
              foregroundColor: Theme.of(context).colorScheme.primary,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.8)))),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _CartButton(
                      backgroundColor: Colors.white.withOpacity(0.8)),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _ImageSkeleton();
                  },
                  errorBuilder: (context, error, stack) => const _ImageError(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title(lang),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.priceUsd.toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        for (final e in product.emojis)
                          Text(e, style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      product.desc(lang),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5, color: const Color(0xFF475467)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await showModalBottomSheet<_BookingResult>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => _BookingSheet(product: product),
              );
              if (result != null && result.qty > 0) {
                state.addToCart(product, qty: result.qty);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t(context, 'Added to cart!', '¡Agregado al carrito!'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
            label: Text(
              t(context, 'Book / Add to cart', 'Reservar / Agregar'),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingResult {
  final DateTime date;
  final int qty;
  const _BookingResult(this.date, this.qty);
}

class _BookingSheet extends StatefulWidget {
  final Product product;
  const _BookingSheet({required this.product});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime date = DateTime.now().add(const Duration(days: 1));
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t(context, 'Select date & quantity', 'Selecciona fecha y cantidad'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: date,
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    icon: const Icon(Icons.today),
                    label: Text(
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _QtyPicker(
                  value: qty,
                  onChanged: (v) => setState(() => qty = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(_BookingResult(date, qty)),
              child: Text(t(context, 'Confirm', 'Confirmar')),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _QtyPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onChanged(max(1, value - 1)),
            icon: Icon(Icons.remove,
                color: Theme.of(context).colorScheme.primary),
          ),
          Text('$value', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16)),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon:
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// CART
// ---------------------------------------------------------------
class _CartButton extends StatelessWidget {
  final Color? backgroundColor;
  const _CartButton({this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CartPage())),
        ),
        if (state.cart.isNotEmpty)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Center(
                child: Text(
                  '${state.cart.fold<int>(0, (sum, item) => sum + item.qty)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'Your Cart', 'Tu Carrito')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: AppBackground(
        child: state.cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove_shopping_cart_outlined,
                        size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(t(context, 'Your cart is empty', 'El carrito está vacío'),
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, i) {
                        final item = state.cart[i];
                        return Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product
                                            .title(KioScope.of(context).lang),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.product.priceUsd.toStringAsFixed(0)} USD',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                _QtyPicker(
                                  value: item.qty,
                                  onChanged: (v) =>
                                      state.setQty(item.product.id, v),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _CartSummary(),
                ],
              ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t(context, 'Total', 'Total'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '\$${state.totalUSD.toStringAsFixed(2)} USD',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CheckoutPage()));
            },
            icon: const Icon(Icons.lock_outline_rounded),
            label: Text(
              t(context, 'Proceed to Checkout', 'Continuar a la Compra'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// PÁGINA DE CHECKOUT
// ---------------------------------------------------------------
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(t(
            context,
            'You must accept the terms and conditions',
            'Debes aceptar los términos y condiciones',
          )),
        ),
      );
      return;
    }

    // Si todo es válido, navega a la página de simulación de pago.
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PaymentProcessingPage(
        customerName: _nameController.text.trim(),
      ),
    ));
  }

  void _showPolicyDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'Checkout', 'Información de Compra')),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF4F7FC),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t(context, 'Customer Information', 'Datos del Cliente'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: t(context, 'Full Name', 'Nombre Completo'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t(context, 'Please enter your name',
                          'Por favor, ingresa tu nombre');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: t(context, 'Email', 'Correo Electrónico'),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t(context, 'Please enter your email',
                          'Por favor, ingresa tu correo');
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return t(context, 'Please enter a valid email',
                          'Por favor, ingresa un correo válido');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: t(context, 'Phone Number', 'Número de Teléfono'),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t(context, 'Please enter your phone number',
                          'Por favor, ingresa tu teléfono');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: CheckboxListTile(
                    title: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: t(context, 'I accept the ', 'Acepto los '),
                          ),
                          TextSpan(
                            text: t(context, 'Terms and Conditions', 'Términos y Condiciones'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showPolicyDialog(
                                  t(context, 'Terms and Conditions','Términos y Condiciones'),
                                  'Aquí va el texto completo de los términos y condiciones del servicio...',
                                );
                              },
                          ),
                          TextSpan(text: t(context, ' and the ', ' y el ')),
                          TextSpan(
                            text: t(context, 'Privacy Policy', 'Aviso de Privacidad'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showPolicyDialog(
                                  t(context, 'Privacy Policy','Aviso de Privacidad'),
                                  'Aquí va el texto completo del aviso de privacidad y manejo de datos personales...',
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    value: _agreedToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t(context, 'Total to pay', 'Total a pagar'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '\$${state.totalUSD.toStringAsFixed(2)} USD',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.credit_card),
                  label: Text(t(context, 'Pay Now', 'Pagar Ahora')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// PÁGINA DE SIMULACIÓN DE PAGO
// ---------------------------------------------------------------
enum PaymentStatus { connecting, awaitingCard, processing, success, failed }

class PaymentProcessingPage extends StatefulWidget {
  final String customerName;
  const PaymentProcessingPage({super.key, required this.customerName});

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  PaymentStatus _status = PaymentStatus.connecting;

  @override
  void initState() {
    super.initState();
    _startPaymentSimulation();
  }

  Future<void> _startPaymentSimulation() async {
    // 1. Conectando
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _status = PaymentStatus.awaitingCard);

    // 2. Esperando tarjeta (mostrando reglas)
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) setState(() => _status = PaymentStatus.processing);

    // 3. Procesando
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Simulación aleatoria de éxito/fallo
      final isSuccess = Random().nextBool();
      setState(() =>
          _status = isSuccess ? PaymentStatus.success : PaymentStatus.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildContentForStatus(),
          ),
        ),
      ),
    );
  }

  Widget _buildContentForStatus() {
    switch (_status) {
      case PaymentStatus.connecting:
        return _PaymentStatusView(
          key: const ValueKey('connecting'),
          icon: const CircularProgressIndicator(strokeWidth: 5),
          title: t(context, 'Connecting...', 'Conectando...'),
          subtitle: t(context, 'Establishing a secure connection with the bank.','Estableciendo conexión segura con el banco.'),
        );
      case PaymentStatus.awaitingCard:
        return _PaymentStatusView(
          key: const ValueKey('awaiting'),
          icon: Icon(Icons.credit_card_rounded, size: 80, color: Theme.of(context).colorScheme.primary),
          title: t(context, 'Please use the card reader', 'Por favor, utilice la terminal'),
          subtitle: t(
              context,
              '1. Insert or tap your card.\n2. Enter your PIN if prompted.\n3. Wait for confirmation.',
              '1. Inserte o acerque su tarjeta.\n2. Ingrese su NIP si se solicita.\n3. Espere la confirmación.'),
        );
      case PaymentStatus.processing:
        return _PaymentStatusView(
          key: const ValueKey('processing'),
          icon: const CircularProgressIndicator(strokeWidth: 5),
          title: t(context, 'Processing payment...', 'Procesando pago...'),
          subtitle: t(context, 'Please do not remove your card.','Por favor, no retire su tarjeta.'),
        );
      case PaymentStatus.success:
        final orderId = 'KIO-${Random().nextInt(900000) + 100000}';
        return _PaymentResultView(
          key: const ValueKey('success'),
          icon: const Icon(Icons.check_circle, size: 100, color: Colors.green),
          title: t(context, 'Payment Successful!', '¡Pago Exitoso!'),
          message:
              '${t(context, 'Thank you, ', 'Gracias, ')}${widget.customerName}!\n${t(context, 'Your order ID is', 'Tu ID de orden es')}: $orderId',
          onFinish: () {
            KioScope.of(context).clearCart();
            Navigator.of(context).popUntil((route) => route.isFirst); // Volver al inicio
          },
        );
      case PaymentStatus.failed:
        return _PaymentResultView(
          key: const ValueKey('failed'),
          icon:
              const Icon(Icons.error, size: 100, color: Colors.redAccent),
          title: t(context, 'Payment Failed', 'El Pago Falló'),
          message: t(
            context,
            'There was an issue processing your payment. Please try again.',
            'Hubo un problema al procesar tu pago. Por favor, inténtalo de nuevo.',
          ),
          isError: true,
          onFinish: () => Navigator.of(context).pop(), // Volver a checkout
        );
    }
  }
}

class _PaymentStatusView extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  const _PaymentStatusView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80, width: 80, child: Center(child: icon)),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF475467), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PaymentResultView extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final bool isError;
  final VoidCallback onFinish;

  const _PaymentResultView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.isError = false,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          icon,
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF475467), height: 1.5),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onFinish,
            style: isError
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  )
                : null,
            child: Text(t(context, isError ? 'Try Again' : 'Finish',
                isError ? 'Intentar de Nuevo' : 'Finalizar')),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// SHARED WIDGETS
// ---------------------------------------------------------------
class _LangPill extends StatelessWidget {
  final bool padded;
  const _LangPill({this.padded = true});

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    final current = state.lang;

    final langs = const [
      (Language.en, 'English', '🇺🇸'),
      (Language.es, 'Español', '🇲🇽'),
    ];

    return PopupMenuButton<Language>(
      tooltip: 'Change language',
      offset: const Offset(0, 50),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      constraints: const BoxConstraints(minWidth: 220),
      onSelected: (opt) => state.lang = opt,
      itemBuilder: (ctx) => [
        for (final (lang, name, flag) in langs)
          PopupMenuItem<Language>(
            value: lang,
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name, style: GoogleFonts.inter(fontSize: 16)),
                ),
                if (lang == current) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current == Language.en ? '🇺🇸' : '🇲🇽',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              current == Language.en ? 'EN' : 'ES',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Gradient gradient;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _FeatureCard({
    required this.gradient,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: gradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Colors.white.withOpacity(0.9)),
              const SizedBox(height: 16),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final String title;
  final Color colorStart;
  final Color colorEnd;
  final IconData icon;
  final KioCategory category;
  const _Feature(this.title, this.colorStart, this.colorEnd, this.icon, this.category);
}