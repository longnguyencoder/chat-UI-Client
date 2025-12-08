import 'package:latlong2/latlong.dart';

import '../models/attraction_model.dart';

class AttractionScape {
  final List<Attraction> hcmAttractions = [
    // ==================== QUẬN 1 ====================
    Attraction(
      id: '1',
      name: 'Nhà thờ Đức Bà',
      address: 'Công xã Paris, Bến Nghé, Quận 1, Hồ Chí Minh',
      description:
          'Nhà thờ chính tòa Đức Bà Sài Gòn là nhà thờ chính tòa của Tổng giáo phận Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://cdn.projectexpedition.com/photos/57e5ff71a61d3_sized.jpg',
      rating: 4.5,
      location: LatLng(10.7798, 106.6990),
      category: 'religious',
      tags: ['nhà thờ', 'kiến trúc', 'lịch sử'],
      openingHours: '8:00 - 11:00, 15:00 - 16:00',
    ),

    Attraction(
      id: '2',
      name: 'Bưu điện Trung tâm Sài Gòn',
      address: '2 Công xã Paris, Bến Nghé, Quận 1, Hồ Chí Minh',
      description:
          'Bưu điện Trung tâm Sài Gòn là một công trình kiến trúc tiêu biểu tại Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://vietnamtour.in/wp-content/uploads/Saigon-Central-Post-Office.jpg',
      rating: 4.3,
      location: LatLng(10.7802, 106.7001),
      category: 'historical',
      tags: ['bưu điện', 'kiến trúc', 'lịch sử'],
      openingHours: '7:00 - 19:00',
    ),

    Attraction(
      id: '3',
      name: 'Chợ Bến Thành',
      address: 'Lê Lợi, Bến Thành, Quận 1, Hồ Chí Minh',
      description:
          'Chợ Bến Thành là một khu chợ nằm ở Quận 1, Thành phố Hồ Chí Minh và là một biểu tượng của thành phố này.',
      imageUrl: 'https://cdn3.ivivu.com/2022/10/cho_ben_thanh_ivivu.jpeg',
      rating: 4.0,
      location: LatLng(10.772427, 106.697988),
      category: 'market',
      tags: ['chợ', 'mua sắm', 'ẩm thực'],
      openingHours: '6:00 - 18:00',
    ),

    Attraction(
      id: '4',
      name: 'Dinh Thống Nhất',
      aliases: ['Dinh Độc Lập', 'Dinh Thống Nhất'],
      address: '135 Nam Kỳ Khởi Nghĩa, Phường Bến Thành, Quận 1, Hồ Chí Minh',
      description:
          'Dinh Độc Lập, còn được gọi là Dinh Thống Nhất, là một công trình kiến trúc lịch sử tại Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/7/7d/20190923_Independence_Palace-10.jpg',
      rating: 4.4,
      location: LatLng(10.7772, 106.6958),
      category: 'historical',
      tags: ['dinh thự', 'lịch sử', 'kiến trúc'],
      openingHours: '8:00 - 11:00, 13:00 - 16:00',
      price: 65000,
    ),

    Attraction(
      id: '5',
      name: 'Nguyễn Huệ',
      address: 'Đường Nguyễn Huệ, Quận 1, Hồ Chí Minh',
      description:
          'Phố đi bộ Nguyễn Huệ là một không gian văn hóa, giải trí và mua sắm tại trung tâm Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Nguyen_Hue_Street_2020.jpg/1920px-Nguyen_Hue_Street_2020.jpg',
      rating: 4.2,
      location: LatLng(10.7743, 106.7038),
      category: 'entertainment',
      tags: ['phố đi bộ', 'giải trí', 'mua sắm'],
      openingHours: '24/7',
    ),

    Attraction(
      id: '6',
      name: 'Chùa Jade Emperor (Chùa Ngọc Hoàng)',
      address: '73 Mai Thị Lựu, Đa Kao, Quận 1, Hồ Chí Minh',
      description:
          'Chùa Ngọc Hoàng là một ngôi chùa Đạo giáo nổi tiếng tại Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Jade_Emperor_Pagoda_Saigon.jpg/800px-Jade_Emperor_Pagoda_Saigon.jpg',
      rating: 4.7,
      location: LatLng(10.7892, 106.6917),
      category: 'religious',
      tags: ['chùa', 'tâm linh', 'văn hóa'],
      openingHours: '6:00 - 18:00',
    ),

    Attraction(
      id: '7',
      name: 'Saigon Skydeck',
      address: 'Tầng 49-52, Bitexco Financial Tower, 2 Hải Triều, Quận 1',
      description:
          'Đài quan sát cao nhất Sài Gòn với tầm nhìn 360 độ toàn thành phố.',
      imageUrl:
          'https://saigoneer.com/images/2019/11/saigon-skydeck-bitexco-tower.jpg',
      rating: 4.3,
      location: LatLng(10.7717, 106.7041),
      category: 'modern',
      tags: ['tòa nhà', 'view đẹp', 'hiện đại'],
      openingHours: '9:30 - 21:30',
      price: 200000,
    ),

    Attraction(
      id: '8',
      name: 'Nhà hát Thành phố',
      address: '7 Công Trường Lam Sơn, Bến Nghé, Quận 1',
      description:
          'Nhà hát Thành phố Hồ Chí Minh là một công trình kiến trúc Pháp cổ điển.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Ho_Chi_Minh_City_Opera_House.jpg/800px-Ho_Chi_Minh_City_Opera_House.jpg',
      rating: 4.4,
      location: LatLng(10.7769, 106.7032),
      category: 'cultural',
      tags: ['nhà hát', 'kiến trúc', 'văn hóa'],
      openingHours: '8:00 - 17:00',
    ),

    Attraction(
      id: '9',
      name: 'Chợ đêm Bến Thành',
      address: 'Công viên 23/9, Quận 1',
      description:
          'Chợ đêm sầm uất với đủ loại đồ ăn, quà lưu niệm và hàng thủ công.',
      imageUrl:
          'https://media.vneconomy.vn/w800/images/upload/2021/09/23/cho-dem-ben-thanh.jpg',
      rating: 4.1,
      location: LatLng(10.7721, 106.6975),
      category: 'market',
      tags: ['chợ đêm', 'ẩm thực', 'mua sắm'],
      openingHours: '18:00 - 23:00',
    ),

    Attraction(
      id: '10',
      name: 'Vincom Center Đồng Khởi',
      address: '72 Lê Thánh Tôn & 45A Lý Tự Trọng, Quận 1',
      description:
          'Trung tâm thương mại cao cấp với nhiều thương hiệu nổi tiếng.',
      imageUrl:
          'https://vincom.com.vn/uploads/images/vincom-center-dong-khoi.jpg',
      rating: 4.2,
      location: LatLng(10.7788, 106.7019),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'mua sắm', 'thời trang'],
      openingHours: '9:30 - 22:00',
    ),

    // ==================== QUẬN 3 ====================
    Attraction(
      id: '11',
      name: 'Bảo tàng Chứng tích Chiến tranh',
      address: '28 Võ Văn Tần, Phường 6, Quận 3, Hồ Chí Minh',
      description:
          'Bảo tàng Chứng tích Chiến tranh là một bảo tàng về Chiến tranh Việt Nam tại Thành phố Hồ Chí Minh.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/War_Remnants_Museum%2C_HCMC%2C_front.JPG/500px-War_Remnants_Museum%2C_HCMC%2C_front.JPG',
      rating: 4.6,
      location: LatLng(10.7798, 106.6922),
      category: 'museum',
      tags: ['bảo tàng', 'lịch sử', 'chiến tranh'],
      openingHours: '7:30 - 17:30',
      price: 40000,
    ),

    Attraction(
      id: '12',
      name: 'Công viên Tao Đàn',
      address: 'Trương Định, Phường 6, Quận 3',
      description:
          'Công viên xanh mát giữa lòng thành phố, nơi lý tưởng để thư giãn.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/08/cong-vien-tao-dan-1.jpg',
      rating: 4.0,
      location: LatLng(10.7836, 106.6889),
      category: 'park',
      tags: ['công viên', 'thư giãn', 'tập thể dục'],
      openingHours: '5:00 - 21:00',
    ),

    Attraction(
      id: '13',
      name: 'Chùa Vĩnh Nghiêm',
      address: '339 Nam Kỳ Khởi Nghĩa, Phường 7, Quận 3',
      description:
          'Ngôi chùa Phật giáo lớn nhất Sài Gòn với kiến trúc Nhật Bản độc đáo.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Vinh_Nghiem_Pagoda_2.jpg/800px-Vinh_Nghiem_Pagoda_2.jpg',
      rating: 4.5,
      location: LatLng(10.7886, 106.6844),
      category: 'religious',
      tags: ['chùa', 'phật giáo', 'kiến trúc'],
      openingHours: '5:00 - 21:00',
    ),

    // ==================== QUẬN 5 ====================
    Attraction(
      id: '14',
      name: 'Chợ Lớn (Chợ Bình Tây)',
      address: '57A Thạp Mười, Phường 2, Quận 6',
      description:
          'Khu chợ lớn nhất Sài Gòn, trung tâm thương mại của cộng đồng Hoa kiều.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Binh_Tay_Market.jpg/800px-Binh_Tay_Market.jpg',
      rating: 4.2,
      location: LatLng(10.7539, 106.6506),
      category: 'market',
      tags: ['chợ', 'hoa kiều', 'mua sắm'],
      openingHours: '6:00 - 18:00',
    ),

    Attraction(
      id: '15',
      name: 'Chùa Bà Thiên Hậu',
      address: '710 Nguyễn Trãi, Phường 11, Quận 5',
      description: 'Ngôi chùa cổ nhất của cộng đồng Hoa kiều tại Sài Gòn.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Thien_Hau_Temple_Ho_Chi_Minh_City.jpg/800px-Thien_Hau_Temple_Ho_Chi_Minh_City.jpg',
      rating: 4.4,
      location: LatLng(10.7558, 106.6653),
      category: 'religious',
      tags: ['chùa', 'hoa kiều', 'lịch sử'],
      openingHours: '6:00 - 18:00',
    ),

    // ==================== QUẬN 7 ====================
    Attraction(
      id: '16',
      name: 'Crescent Mall',
      address: '101 Tôn Dật Tiên, Tân Phú, Quận 7',
      description:
          'Trung tâm thương mại hiện đại với nhiều cửa hàng và nhà hàng.',
      imageUrl:
          'https://crescentmall.com.vn/uploads/images/crescent-mall-exterior.jpg',
      rating: 4.3,
      location: LatLng(10.7411, 106.7197),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'mua sắm', 'giải trí'],
      openingHours: '9:30 - 22:00',
    ),

    Attraction(
      id: '17',
      name: 'Lotte Mart Quận 7',
      address: '469 Nguyễn Hữu Thọ, Tân Hưng, Quận 7',
      description:
          'Siêu thị lớn với đầy đủ mặt hàng và khu vui chơi cho trẻ em.',
      imageUrl: 'https://lottemart.com.vn/uploads/lotte-mart-q7.jpg',
      rating: 4.1,
      location: LatLng(10.7364, 106.7025),
      category: 'shopping',
      tags: ['siêu thị', 'mua sắm', 'gia đình'],
      openingHours: '8:00 - 22:00',
    ),

    // ==================== BÌNH THẠNH ====================
    Attraction(
      id: '18',
      name: 'Landmark 81',
      address: '720A Điện Biên Phủ, Bình Thạnh, Hồ Chí Minh',
      description:
          'Landmark 81 là tòa nhà chọc trời cao nhất Việt Nam và Đông Nam Á.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/e/e6/Ho_Chi_Minh_City_panorama_2019_%28cropped%29.jpg',
      rating: 4.3,
      location: LatLng(10.7953, 106.7218),
      category: 'modern',
      tags: ['tòa nhà', 'hiện đại', 'view đẹp'],
      openingHours: '9:00 - 22:00',
      price: 200000,
    ),

    Attraction(
      id: '19',
      name: 'Vincom Mega Mall Thảo Điền',
      address: '159 Xa lộ Hà Nội, Thảo Điền, Quận 2',
      description: 'Trung tâm thương mại lớn nhất khu Đông Sài Gòn.',
      imageUrl: 'https://vincom.com.vn/uploads/vincom-mega-mall-thao-dien.jpg',
      rating: 4.4,
      location: LatLng(10.8031, 106.7344),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'mua sắm', 'giải trí'],
      openingHours: '9:30 - 22:00',
    ),

    // ==================== CỦ CHI ====================
    Attraction(
      id: '20',
      name: 'Địa đạo Củ Chi',
      address: 'Phú Hiệp, Củ Chi, Hồ Chí Minh',
      description: 'Hệ thống địa đạo nổi tiếng thời kỳ kháng chiến chống Mỹ.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Cu_Chi_tunnels_entrance.jpg/800px-Cu_Chi_tunnels_entrance.jpg',
      rating: 4.5,
      location: LatLng(11.1394, 106.4969),
      category: 'historical',
      tags: ['địa đạo', 'lịch sử', 'chiến tranh'],
      openingHours: '7:00 - 17:00',
      price: 110000,
    ),

    Attraction(
      id: '21',
      name: 'Rừng Sác Củ Chi',
      address: 'Xã Phú Mỹ Hưng, Củ Chi',
      description: 'Khu rừng ngập mặn với hệ sinh thái đa dạng.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/05/rung-sac-cu-chi.jpg',
      rating: 4.2,
      location: LatLng(11.0833, 106.4167),
      category: 'nature',
      tags: ['rừng', 'sinh thái', 'thiên nhiên'],
      openingHours: '7:00 - 17:00',
      price: 50000,
    ),

    // ==================== CẦN GIỜ ====================
    Attraction(
      id: '22',
      name: 'Rừng ngập mặn Cần Giờ',
      address: 'Cần Thạnh, Cần Giờ, Hồ Chí Minh',
      description: 'Khu dự trữ sinh quyển thế giới với rừng ngập mặn rộng lớn.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Can_Gio_Mangrove_Forest.jpg/800px-Can_Gio_Mangrove_Forest.jpg',
      rating: 4.3,
      location: LatLng(10.4167, 106.9500),
      category: 'nature',
      tags: ['rừng ngập mặn', 'sinh thái', 'unesco'],
      openingHours: '7:00 - 17:00',
      price: 15000,
    ),

    Attraction(
      id: '23',
      name: 'Bãi biển 30/4 Cần Giờ',
      address: 'Cần Thạnh, Cần Giờ',
      description: 'Bãi biển gần Sài Gòn nhất với cát đen đặc trưng.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/06/bai-bien-30-4-can-gio.jpg',
      rating: 3.8,
      location: LatLng(10.4000, 106.9667),
      category: 'beach',
      tags: ['bãi biển', 'du lịch', 'nghỉ dưỡng'],
      openingHours: '6:00 - 18:00',
    ),

    Attraction(
      id: '24',
      name: 'Khu du lịch Vàm Sát',
      address: 'Cần Thạnh, Cần Giờ',
      description: 'Khu du lịch sinh thái với đường mòn xuyên rừng ngập mặn.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/06/vam-sat-can-gio.jpg',
      rating: 4.1,
      location: LatLng(10.4333, 106.9333),
      category: 'nature',
      tags: ['sinh thái', 'trekking', 'rừng'],
      openingHours: '7:00 - 17:00',
      price: 20000,
    ),

    // ==================== BÌNH CHÁNH ====================
    Attraction(
      id: '25',
      name: 'Chùa Giac Lam',
      address: '118 Lạc Long Quân, Phường 10, Tân Bình',
      description: 'Ngôi chùa cổ nhất Sài Gòn được xây dựng từ năm 1744.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Giac_Lam_Pagoda.jpg/800px-Giac_Lam_Pagoda.jpg',
      rating: 4.6,
      location: LatLng(10.7944, 106.6361),
      category: 'religious',
      tags: ['chùa', 'cổ kính', 'lịch sử'],
      openingHours: '5:00 - 21:00',
    ),

    Attraction(
      id: '26',
      name: 'Khu du lịch Suối Tiên',
      address: '120 Xa lộ Hà Nội, Tân Phú, Quận 9',
      description: 'Công viên giải trí lớn với nhiều trò chơi và biểu diễn.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Suoi_Tien_Theme_Park.jpg/800px-Suoi_Tien_Theme_Park.jpg',
      rating: 4.0,
      location: LatLng(10.8500, 106.8167),
      category: 'entertainment',
      tags: ['công viên giải trí', 'gia đình', 'vui chơi'],
      openingHours: '8:00 - 18:00',
      price: 120000,
    ),

    // ==================== HÓC MÔN ====================
    Attraction(
      id: '27',
      name: 'Khu di tích Căn cứ Đức Hòa',
      address: 'Đức Hòa, Long An (gần Hóc Môn)',
      description: 'Căn cứ kháng chiến lịch sử với hệ thống hầm ngầm.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/07/can-cu-duc-hoa.jpg',
      rating: 4.2,
      location: LatLng(10.8833, 106.4167),
      category: 'historical',
      tags: ['di tích', 'lịch sử', 'kháng chiến'],
      openingHours: '7:00 - 17:00',
      price: 30000,
    ),

    // ==================== NHÀ BÈ ====================
    Attraction(
      id: '28',
      name: 'Khu du lịch sinh thái Tre Việt',
      address: 'Phước Lộc, Nhà Bè',
      description: 'Khu du lịch sinh thái với không gian xanh mát.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/08/tre-viet-nha-be.jpg',
      rating: 4.0,
      location: LatLng(10.6833, 106.7500),
      category: 'nature',
      tags: ['sinh thái', 'thiên nhiên', 'nghỉ dưỡng'],
      openingHours: '8:00 - 17:00',
      price: 80000,
    ),

    // ==================== THỦ ĐỨC ====================
    Attraction(
      id: '29',
      name: 'Đại học Quốc gia TP.HCM',
      address: 'Linh Trung, Thủ Đức',
      description: 'Khu đại học lớn nhất miền Nam với kiến trúc hiện đại.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/VNU_HCM.jpg/800px-VNU_HCM.jpg',
      rating: 4.1,
      location: LatLng(10.8700, 106.8000),
      category: 'educational',
      tags: ['đại học', 'giáo dục', 'kiến trúc'],
      openingHours: '7:00 - 17:00',
    ),

    Attraction(
      id: '30',
      name: 'Gigamall Thủ Đức',
      address: '240-242 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức',
      description: 'Trung tâm thương mại lớn tại khu Đông với nhiều tiện ích.',
      imageUrl: 'https://gigamall.com.vn/uploads/gigamall-thu-duc.jpg',
      rating: 4.2,
      location: LatLng(10.8450, 106.7800),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'mua sắm', 'giải trí'],
      openingHours: '9:00 - 22:00',
    ),

    // ==================== QUẬN 4 ====================
    Attraction(
      id: '31',
      name: 'Cầu Khánh Hội',
      address: 'Khánh Hội, Quận 4',
      description: 'Cầu xoay độc đáo bắc qua kênh Tẻ với kiến trúc đặc biệt.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/09/cau-khanh-hoi.jpg',
      rating: 4.0,
      location: LatLng(10.7611, 106.7056),
      category: 'architectural',
      tags: ['cầu', 'kiến trúc', 'độc đáo'],
      openingHours: '24/7',
    ),

    // ==================== QUẬN 8 ====================
    Attraction(
      id: '32',
      name: 'Chợ hoa Bình Đông',
      address: '1A Bình Đông, Phường 15, Quận 8, Thành phố Hồ Chí Minh',
      description: 'Chợ hoa lớn nhất Sài Gòn với đa dạng các loại hoa tươi, cây cảnh và phụ kiện trang trí. Đây là nơi cung cấp hoa cho các cửa hàng hoa trong thành phố, mở cửa từ rất sớm và nhộn nhịp nhất vào buổi sáng.',
      imageUrl: 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=800&h=600&fit=crop',
      rating: 4.4,
      location: LatLng(10.7333, 106.6833),
      category: 'cultural',
      tags: ['chợ', 'mua sắm', 'hoa tươi', 'cây cảnh', 'văn hóa'],
      openingHours: '04:00 - 10:00',
    ),

    // ==================== QUẬN 10 ====================
    Attraction(
      id: '33',
      name: 'Chùa Ấn Quang',
      address: '3 Ấn Quang, Phường 4, Quận 10',
      description:
          'Ngôi chùa nổi tiếng với kiến trúc cổ kính và không gian yên tĩnh.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/11/chua-an-quang.jpg',
      rating: 4.3,
      location: LatLng(10.7722, 106.6694),
      category: 'religious',
      tags: ['chùa', 'phật giáo', 'yên tĩnh'],
      openingHours: '5:00 - 21:00',
    ),

    // ==================== QUẬN 11 ====================
    Attraction(
      id: '34',
      name: 'Đầm Sen Water Park',
      address: '3 Hòa Bình, Phường 3, Quận 11',
      description: 'Công viên nước lớn nhất Sài Gòn với nhiều trò chơi thú vị.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Dam_Sen_Water_Park.jpg/800px-Dam_Sen_Water_Park.jpg',
      rating: 4.1,
      location: LatLng(10.7639, 106.6472),
      category: 'entertainment',
      tags: ['công viên nước', 'gia đình', 'vui chơi'],
      openingHours: '8:00 - 18:00',
      price: 130000,
    ),

    Attraction(
      id: '35',
      name: 'Công viên Đầm Sen',
      address: '3 Hòa Bình, Phường 3, Quận 11',
      description: 'Công viên giải trí với hồ sen đẹp và nhiều trò chơi.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2019/12/cong-vien-dam-sen.jpg',
      rating: 4.0,
      location: LatLng(10.7644, 106.6467),
      category: 'entertainment',
      tags: ['công viên', 'gia đình', 'giải trí'],
      openingHours: '8:00 - 18:00',
      price: 50000,
    ),

    // ==================== QUẬN 12 ====================
    Attraction(
      id: '36',
      name: 'Chùa Gò',
      address: 'Gò Vấp, Quận 12',
      description: 'Ngôi chùa cổ với kiến trúc độc đáo trên đồi cao.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/01/chua-go.jpg',
      rating: 4.2,
      location: LatLng(10.8167, 106.6500),
      category: 'religious',
      tags: ['chùa', 'đồi cao', 'view đẹp'],
      openingHours: '5:00 - 21:00',
    ),

    // ==================== TÂN BÌNH ====================
    Attraction(
      id: '37',
      name: 'Sân bay Tân Sơn Nhất',
      address: 'Tân Sơn Nhất, Tân Bình',
      description: 'Sân bay quốc tế lớn nhất Việt Nam.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Tan_Son_Nhat_Airport.jpg/800px-Tan_Son_Nhat_Airport.jpg',
      rating: 3.8,
      location: LatLng(10.8167, 106.6667),
      category: 'transportation',
      tags: ['sân bay', 'giao thông', 'quốc tế'],
      openingHours: '24/7',
    ),

    // ==================== TÂN PHÚ ====================
    Attraction(
      id: '38',
      name: 'Chùa Tây An',
      address: 'Tây Thạnh, Tân Phú',
      description: 'Ngôi chùa nổi tiếng với tượng Phật Di Lặc lớn.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/02/chua-tay-an.jpg',
      rating: 4.3,
      location: LatLng(10.7833, 106.6167),
      category: 'religious',
      tags: ['chùa', 'phật di lặc', 'linh thiêng'],
      openingHours: '5:00 - 21:00',
    ),

    // ==================== GÒ VẤP ====================
    Attraction(
      id: '39',
      name: 'Emart Gò Vấp',
      address: '12Bis Nguyễn Thái Sơn, Gò Vấp',
      description: 'Trung tâm thương mại Hàn Quốc với nhiều sản phẩm đa dạng.',
      imageUrl: 'https://emart.com.vn/uploads/emart-go-vap.jpg',
      rating: 4.1,
      location: LatLng(10.8333, 106.6833),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'hàn quốc', 'mua sắm'],
      openingHours: '8:00 - 22:00',
    ),

    // ==================== PHÚ NHUẬN ====================
    Attraction(
      id: '40',
      name: 'Chùa Xá Lợi',
      address: '89 Bà Huyện Thanh Quan, Phường 7, Quận 3',
      description: 'Ngôi chùa lịch sử nổi tiếng với sự kiện Phật giáo 1963.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Xa_Loi_Pagoda.jpg/800px-Xa_Loi_Pagoda.jpg',
      rating: 4.4,
      location: LatLng(10.7889, 106.6944),
      category: 'religious',
      tags: ['chùa', 'lịch sử', 'phật giáo'],
      openingHours: '5:00 - 21:00',
    ),

    // ==================== BÌNH TÂN ====================
    Attraction(
      id: '41',
      name: 'Aeon Mall Bình Tân',
      address: '1 Đường số 17A, Bình Trị Đông B, Bình Tân',
      description: 'Trung tâm thương mại Nhật Bản lớn với nhiều thương hiệu.',
      imageUrl:
          'https://aeonmall-binhtancangio.com.vn/uploads/aeon-mall-binh-tan.jpg',
      rating: 4.3,
      location: LatLng(10.7500, 106.6000),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'nhật bản', 'hiện đại'],
      openingHours: '9:00 - 22:00',
    ),

    // ==================== QUẬN 2 (CŨ) ====================
    Attraction(
      id: '42',
      name: 'Khu đô thị Sala',
      address: 'Mai Chi Thọ, Thủ Thiêm, Quận 2',
      description:
          'Khu đô thị cao cấp với kiến trúc hiện đại bên sông Sài Gòn.',
      imageUrl: 'https://sala.com.vn/uploads/sala-thu-thiem.jpg',
      rating: 4.2,
      location: LatLng(10.7833, 106.7333),
      category: 'modern',
      tags: ['đô thị', 'hiện đại', 'cao cấp'],
      openingHours: '24/7',
    ),

    Attraction(
      id: '43',
      name: 'The Observatory',
      address: 'Lầu 52, Landmark 81, Bình Thạnh',
      description: 'Đài quan sát cao nhất Đông Nam Á với tầm nhìn 360 độ.',
      imageUrl: 'https://theobservatory.vn/uploads/observatory-landmark81.jpg',
      rating: 4.5,
      location: LatLng(10.7953, 106.7218),
      category: 'modern',
      tags: ['đài quan sát', 'view đẹp', 'cao nhất'],
      openingHours: '9:00 - 21:00',
      price: 350000,
    ),

    // ==================== ẨM THỰC ====================
    Attraction(
      id: '44',
      name: 'Chợ Ẩm thực Bến Thành',
      address: 'Chợ Bến Thành, Quận 1',
      description: 'Khu ẩm thực tập trung các món đặc sản Sài Gòn.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/03/am-thuc-ben-thanh.jpg',
      rating: 4.2,
      location: LatLng(10.7724, 106.6980),
      category: 'food',
      tags: ['ẩm thực', 'đặc sản', 'street food'],
      openingHours: '6:00 - 22:00',
    ),

    Attraction(
      id: '45',
      name: 'Phố ẩm thực Vĩnh Khánh',
      address: 'Vĩnh Khánh, Quận 4',
      description: 'Phố ẩm thực nổi tiếng với các món nướng và hải sản.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/04/pho-am-thuc-vinh-khanh.jpg',
      rating: 4.3,
      location: LatLng(10.7556, 106.7083),
      category: 'food',
      tags: ['ẩm thực', 'nướng', 'hải sản'],
      openingHours: '17:00 - 24:00',
    ),

    // ==================== GIẢI TRÍ VỀ ĐÊM ====================
    Attraction(
      id: '46',
      name: 'Phố Tây Bùi Viện',
      address: 'Bùi Viện, Phường Phạm Ngũ Lão, Quận 1',
      description: 'Khu phố Tây sầm uất với nhiều quán bar và nhà hàng.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/05/pho-tay-bui-vien.jpg',
      rating: 4.0,
      location: LatLng(10.7667, 106.6917),
      category: 'nightlife',
      tags: ['phố tây', 'bar', 'nightlife'],
      openingHours: '18:00 - 2:00',
    ),

    Attraction(
      id: '47',
      name: 'Bitexco Sky Bar',
      address: 'Tầng 50, Bitexco Financial Tower, Quận 1',
      description: 'Sky bar cao cấp với view toàn cảnh thành phố.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/06/bitexco-sky-bar.jpg',
      rating: 4.4,
      location: LatLng(10.7717, 106.7041),
      category: 'nightlife',
      tags: ['sky bar', 'view đẹp', 'cao cấp'],
      openingHours: '17:00 - 1:00',
      price: 300000,
    ),

    // ==================== CÔNG VIÊN & THIÊN NHIÊN ====================
    Attraction(
      id: '48',
      name: 'Công viên 23/9',
      address: 'Phạm Ngũ Lão, Quận 1',
      description:
          'Công viên trung tâm thành phố với nhiều hoạt động giải trí.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/07/cong-vien-23-9.jpg',
      rating: 3.9,
      location: LatLng(10.7694, 106.6944),
      category: 'park',
      tags: ['công viên', 'trung tâm', 'giải trí'],
      openingHours: '5:00 - 22:00',
    ),

    Attraction(
      id: '49',
      name: 'Công viên Gia Định',
      address: 'Hoàng Minh Giám, Phú Nhuận',
      description: 'Công viên lớn với hồ nước và không gian xanh mát.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/08/cong-vien-gia-dinh.jpg',
      rating: 4.1,
      location: LatLng(10.8000, 106.6833),
      category: 'park',
      tags: ['công viên', 'hồ nước', 'xanh mát'],
      openingHours: '5:00 - 21:00',
    ),

    Attraction(
      id: '50',
      name: 'Công viên Lê Văn Tám',
      address: 'Hai Bà Trưng, Quận 1',
      description: 'Công viên nhỏ giữa trung tâm thành phố với nhiều cây xanh.',
      imageUrl:
          'https://dulichkhampha24.com/wp-content/uploads/2020/09/cong-vien-le-van-tam.jpg',
      rating: 3.8,
      location: LatLng(10.7833, 106.6944),
      category: 'park',
      tags: ['công viên', 'cây xanh', 'thư giãn'],
      openingHours: '5:00 - 21:00',
    ),

    Attraction(
      id: '51',
      name: 'Thảo Cầm Viên',
      address: 'Bến Bạch Đằng, Hồ Chí Minh',
      description: 'Thảo Cầm Viên (Sài Gòn Zoo) là vườn thú và thực vật lâu đời tại thành phố Hồ Chí Minh.',
      imageUrl: 'assets/images/attractions/thao_cam_vien.jpg',
      rating: 4.3,
      location: LatLng(10.7868, 106.7051),
      category: 'park',
      tags: ['vườn thú', 'công viên', 'giải trí'],
      openingHours: '7:00 - 18:30',
      price: 50000,
    ),

    Attraction(
      id: '52',
      name: 'Đường sách Nguyễn Văn Bình',
      address: 'Nguyễn Văn Bình, Phường Bến Nghé, Quận 1, Hồ Chí Minh',
      description: 'Đường sách Nguyễn Văn Bình là tuyến phố chuyên về sách và văn hóa đọc tại trung tâm thành phố.',
      imageUrl: 'assets/images/attractions/duong_sach.jpg',
      rating: 4.4,
      location: LatLng(10.7739, 106.7031),
      category: 'culture',
      tags: ['sách', 'văn hóa', 'mua sắm'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '53',
      name: 'Saigon Garden',
      address: 'Quận 1, Hồ Chí Minh',
      description: 'Saigon Garden là không gian xanh giữa lòng thành phố, nơi thư giãn và giải trí.',
      imageUrl: 'assets/images/attractions/saigon_garden.jpg',
      rating: 4.2,
      location: LatLng(10.7800, 106.7000),
      category: 'park',
      tags: ['công viên', 'giải trí', 'thư giãn'],
      openingHours: '6:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '54',
      name: 'Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh',
      address: '97A Phó Đức Chính, Phường Nguyễn Thái Bình, Quận 1, Hồ Chí Minh',
      description: 'Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh là điểm đến yêu thích của những người yêu nghệ thuật và văn hóa. Bảo tàng là nơi thu thập, trưng bày, bảo quản các tác phẩm nghệ thuật hiện đại, đương đại của các nghệ sĩ Việt Nam và quốc tế.',
      imageUrl: 'assets/images/attractions/bao_tang_my_thuat.jpg',
      rating: 4.5,
      location: LatLng(10.7692, 106.7033),
      category: 'museum',
      tags: ['bảo tàng', 'nghệ thuật', 'văn hóa'],
      openingHours: '9:00 - 17:00',
      price: 30000,
    ),

    Attraction(
      id: '55',
      name: 'Phố Nhật Little Japan Sài Gòn',
      address: 'Đường Thái Văn Lung, Phường Bến Nghé, Quận 1, Hồ Chí Minh',
      description: 'Phố Nhật Sài Gòn Little Japan là một khu vực tập trung nhiều cửa hàng, quán cà phê, nhà hàng Nhật Bản.',
      imageUrl: 'assets/images/attractions/pho_nhat.jpg',
      rating: 4.3,
      location: LatLng(10.7778, 106.7042),
      category: 'culture',
      tags: ['ẩm thực', 'văn hóa', 'nhật bản'],
      openingHours: '9:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '56',
      name: 'Saigon Outcast',
      address: '188/1 Nguyễn Văn Hưởng, Phường Thảo Điền, Quận 2, Hồ Chí Minh',
      description: 'Saigon Outcast là tổ hợp vui chơi, giải trí, sáng tạo đậm chất nghệ thuật đường phố.',
      imageUrl: 'assets/images/attractions/saigon_outcast.jpg',
      rating: 4.4,
      location: LatLng(10.8066, 106.7373),
      category: 'entertainment',
      tags: ['nghệ thuật', 'giải trí', 'sáng tạo'],
      openingHours: '9:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '57',
      name: 'Family Garden',
      address: '28 Thảo Điền, Phường Thảo Điền, Quận 2, Hồ Chí Minh',
      description: 'Family Garden là một trong những địa điểm đang hot ở Sài Gòn với nhiều khu vui chơi hấp dẫn.',
      imageUrl: 'assets/images/attractions/family_garden.jpg',
      rating: 4.2,
      location: LatLng(10.8030, 106.7350),
      category: 'entertainment',
      tags: ['gia đình', 'vui chơi', 'giải trí'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '58',
      name: 'Thảo Điền Village',
      address: '89 – 197 Nguyễn Văn Hưởng, Phường Thảo Điền, Quận 2, Hồ Chí Minh',
      description: 'Thảo Điền Village có một không gian thoáng đãng, xanh mát cực kỳ dễ chịu.',
      imageUrl: 'assets/images/attractions/thao_dien_village.jpg',
      rating: 4.3,
      location: LatLng(10.8080, 106.7390),
      category: 'entertainment',
      tags: ['thư giãn', 'không gian xanh', 'giải trí'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '59',
      name: 'Khu trượt tuyết Snow Town',
      address: 'Lầu 3 The CBD Premium Home, 125 Đồng Văn Cống, Phường Thạnh Mỹ Lợi, Thành phố Thủ Đức, Hồ Chí Minh',
      description: 'Snow Town là một khu trượt tuyết nhân tạo trong nhà nổi tiếng của Sài Gòn.',
      imageUrl: 'assets/images/attractions/snow_town.jpg',
      rating: 4.1,
      location: LatLng(10.7680, 106.7750),
      category: 'entertainment',
      tags: ['trượt tuyết', 'giải trí', 'trong nhà'],
      openingHours: '9:30 - 21:30',
      price: 200000,
    ),

    Attraction(
      id: '60',
      name: 'Công viên bờ sông Sài Gòn',
      address: 'Khu đô thị mới Thủ Thiêm, Thành phố Thủ Đức, Hồ Chí Minh',
      description: 'Công viên bờ sông Sài Gòn là một tụ điểm vui chơi mới của thành phố. Tọa lạc tại khu đô thị mới Thủ Thiêm.',
      imageUrl: 'assets/images/attractions/cong_vien_bo_song.jpg',
      rating: 4.4,
      location: LatLng(10.7830, 106.7220),
      category: 'park',
      tags: ['công viên', 'bờ sông', 'thư giãn'],
      openingHours: '5:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '61',
      name: 'Bãi thả diều chân cầu Thủ Thiêm',
      address: 'Khu đô thị mới Thủ Thiêm, Quận 2, Hồ Chí Minh',
      description: 'Bãi diều rộng lớn, người bán, người thả diều tấp nập và những con diều nhiều màu sắc trên bầu trời.',
      imageUrl: 'assets/images/attractions/bai_tha_dieu.jpg',
      rating: 4.2,
      location: LatLng(10.7850, 106.7240),
      category: 'entertainment',
      tags: ['thả diều', 'giải trí', 'ngoài trời'],
      openingHours: '15:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '62',
      name: 'Nhà thờ Giáo xứ Tân Định',
      address: '289 Hai Bà Trưng, Phường 8, Quận 3, Hồ Chí Minh',
      description: 'Nhà thờ Giáo xứ Tân Định với không gian ngập tràn sắc hồng dịu dàng là một địa điểm check-in quen thuộc đối với các tín đồ thích khám phá.',
      imageUrl: 'assets/images/attractions/nha_tho_tan_dinh.jpg',
      rating: 4.6,
      location: LatLng(10.7890, 106.6910),
      category: 'religious',
      tags: ['nhà thờ', 'kiến trúc', 'tôn giáo'],
      openingHours: '8:00 - 12:00, 14:00 - 17:00',
      price: 0,
    ),

    Attraction(
      id: '63',
      name: 'Phố ẩm thực Nguyễn Thượng Hiền',
      address: 'Đường Nguyễn Thượng Hiền, Phường 4, 5, Quận 3, Hồ Chí Minh',
      description: 'Phố ẩm thực Nguyễn Thượng Hiền là một tuyến phố ngắn khá sầm uất với nhiều mặt hàng đồ ăn thức uống nổi tiếng.',
      imageUrl: 'assets/images/attractions/pho_am_thuc.jpg',
      rating: 4.5,
      location: LatLng(10.7750, 106.6780),
      category: 'food',
      tags: ['ẩm thực', 'đường phố', 'ăn uống'],
      openingHours: '19:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '64',
      name: 'Hồ bơi Kỳ Đồng',
      address: '40 Kỳ Đồng, Phường 9, Quận 3, Hồ Chí Minh',
      description: 'Đây là địa điểm vui chơi và sinh hoạt thể thao quen thuộc đối với những bạn trẻ yêu thích bơi lội cùng các gia đình có con nhỏ tại quận 3.',
      imageUrl: 'assets/images/attractions/ho_boi_ky_dong.jpg',
      rating: 4.0,
      location: LatLng(10.7830, 106.6820),
      category: 'sport',
      tags: ['bơi lội', 'thể thao', 'giải trí'],
      openingHours: '6:00 - 18:00',
      price: 50000,
    ),

    Attraction(
      id: '65',
      name: 'The Box Market Quận 3',
      address: 'Trung tâm văn hóa thể thao quận 3 - 136 Cách mạng Tháng Tám, Quận 3, Hồ Chí Minh',
      description: 'The Box Market là phiên chợ cuối tuần đặc biệt được diễn ra ở Trung tâm Văn hóa Thể thao Quận 3.',
      imageUrl: 'assets/images/attractions/box_market.jpg',
      rating: 4.3,
      location: LatLng(10.7790, 106.6830),
      category: 'shopping',
      tags: ['chợ', 'mua sắm', 'giải trí'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '66',
      name: 'Poc Poc Beer Garden',
      address: '79A Nguyễn Đình Chiểu, Phường 6, Quận 3, Hồ Chí Minh',
      description: 'Poc Poc Beer Garden là địa điểm giải trí quen thuộc với những tín đồ du lịch thích sự sôi động và náo nhiệt của tiếng nhạc.',
      imageUrl: 'assets/images/attractions/poc_poc.jpg',
      rating: 4.2,
      location: LatLng(10.7770, 106.6850),
      category: 'nightlife',
      tags: ['bia', 'giải trí', 'âm nhạc'],
      openingHours: '17:00 - 2:00',
      price: 0,
    ),

    Attraction(
      id: '67',
      name: 'Chùa Pháp Hoa',
      address: '870 đường Trường Sa, Phường 14, Quận 3, Hồ Chí Minh',
      description: 'Chùa Pháp Hoa là địa điểm tôn giáo nổi tiếng tại quận 3 với kiến trúc độc đáo với không gian thoáng đãng nằm cạnh một dòng kênh ở trung tâm thành phố.',
      imageUrl: 'assets/images/attractions/chua_phap_hoa.jpg',
      rating: 4.5,
      location: LatLng(10.7900, 106.6750),
      category: 'religious',
      tags: ['chùa', 'tôn giáo', 'kiến trúc'],
      openingHours: '6:00 - 11:30, 13:30 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '68',
      name: 'Cầu Mống',
      address: '33 Bến Vân Đồn, Phường 7, Quận 4, Hồ Chí Minh',
      description: 'Cây cầu này luôn thu hút đông đảo các bạn trẻ với nhiều hoạt động sôi nổi như chụp hình check-in, ngắm bình minh hay hoàng hôn vô cùng đẹp, hẹn hò lãng mạn hay thưởng thức những món ăn ở các gánh hàng rong.',
      imageUrl: 'assets/images/attractions/cau_mong.jpg',
      rating: 4.3,
      location: LatLng(10.7620, 106.7050),
      category: 'landmark',
      tags: ['cầu', 'check-in', 'hoàng hôn'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '69',
      name: 'Bến Nhà Rồng',
      address: '1 Nguyễn Tất Thành, Phường 12, Quận 4, Hồ Chí Minh',
      description: 'Bến Nhà Rồng còn mang phong cách hữu tình ngay bờ sông Sài Gòn với không khí thoáng đãng nên rất đông du khách cả trong và ngoài nước đến đây.',
      imageUrl: 'assets/images/attractions/ben_nha_rong.jpg',
      rating: 4.4,
      location: LatLng(10.7630, 106.7040),
      category: 'landmark',
      tags: ['lịch sử', 'bờ sông', 'du lịch'],
      openingHours: '8:00 - 17:00',
      price: 20000,
    ),

    Attraction(
      id: '70',
      name: 'Chợ Xóm Chiếu Quận 4',
      address: '92B/20 Tôn Thất Thuyết, Phường 16, Quận 4, Hồ Chí Minh',
      description: 'Là một trong những địa điểm ăn uống, vui chơi sầm uất nhất nhì Sài Gòn, chợ Xóm Chiếu luôn thu hút đông đảo du khách với những món ăn vặt hấp dẫn.',
      imageUrl: 'assets/images/attractions/cho_xom_chieu.jpg',
      rating: 4.1,
      location: LatLng(10.7580, 106.7080),
      category: 'food',
      tags: ['chợ', 'ẩm thực', 'ăn vặt'],
      openingHours: '6:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '71',
      name: 'Công viên Khánh Hội Quận 4',
      address: 'Đường số 48, Phường 5, Quận 4, Hồ Chí Minh',
      description: 'Được mệnh danh là "lá phổi xanh" của Quận 4 Thành phố Hồ Chí Minh, công viên Khánh Hội có diện tích hơn 4,9ha được phủ xanh bằng rất nhiều loại cây cối khác nhau.',
      imageUrl: 'assets/images/attractions/cong_vien_khanh_hoi.jpg',
      rating: 4.2,
      location: LatLng(10.7550, 106.7070),
      category: 'park',
      tags: ['công viên', 'không gian xanh', 'thư giãn'],
      openingHours: '5:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '72',
      name: 'Phố người Hoa Quận 5',
      address: 'Trần Hưng Đạo, Phường 6, Quận 5, Hồ Chí Minh',
      description: 'Khu phố có nhiều người Hoa sinh sống nhất tại Sài Gòn để trải nghiệm nền văn hóa Trung Hoa, tinh túy ẩm thực nổi tiếng.',
      imageUrl: 'assets/images/attractions/pho_nguoi_hoa.jpg',
      rating: 4.4,
      location: LatLng(10.7520, 106.6580),
      category: 'culture',
      tags: ['văn hóa', 'ẩm thực', 'người hoa'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '73',
      name: 'Phố đèn lồng Lương Nhữ Học Quận 5',
      address: 'Lương Nhữ Học, Phường 11, Quận 5, Hồ Chí Minh',
      description: 'Phố đèn lồng Lương Nhữ Học Quận 5 là một trong những điểm vui chơi Sài Gòn về đêm nổi tiếng nhất Sài thành. Bởi nơi đây có những dãy phố bán hàng ngàn chiếc đèn lồng với nhiều màu sắc khác nhau.',
      imageUrl: 'assets/images/attractions/pho_den_long.jpg',
      rating: 4.5,
      location: LatLng(10.7530, 106.6590),
      category: 'shopping',
      tags: ['đèn lồng', 'mua sắm', 'văn hóa'],
      openingHours: '9:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '74',
      name: 'Chợ Thủ Đô Quận 5',
      address: '220 Phùng Hưng, Phường 14, Quận 5, Hồ Chí Minh',
      description: 'Chợ Thủ Đô là một trong những địa điểm vui chơi ở Quận 5 được rất nhiều người ghé thăm để thưởng thức các loại đặc sản, tinh túy ẩm thực Sài Gòn.',
      imageUrl: 'assets/images/attractions/cho_thu_do.jpg',
      rating: 4.0,
      location: LatLng(10.7540, 106.6600),
      category: 'food',
      tags: ['chợ', 'ẩm thực', 'mua sắm'],
      openingHours: '6:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '75',
      name: 'The Garden Mall',
      address: '190 Hồng Bàng, Phường 12, Quận 5, Hồ Chí Minh',
      description: 'Trung tâm thương mại hiện đại với nhiều cửa hàng và khu vui chơi giải trí.',
      imageUrl: 'assets/images/attractions/garden_mall.jpg',
      rating: 4.3,
      location: LatLng(10.7550, 106.6610),
      category: 'shopping',
      tags: ['mua sắm', 'giải trí', 'trung tâm thương mại'],
      openingHours: '9:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '76',
      name: 'Chợ An Đông',
      address: '34 - 36 An Dương Vương, Phường 9, Quận 5, Hồ Chí Minh',
      description: 'An Đông là một ngôi chợ có tuổi đời khá lâu tại Sài Gòn, đây là cụm chợ đầu mối được đánh giá là lớn nhất tại Việt Nam hiện nay.',
      imageUrl: 'assets/images/attractions/cho_an_dong.jpg',
      rating: 4.1,
      location: LatLng(10.7560, 106.6620),
      category: 'shopping',
      tags: ['chợ', 'mua sắm', 'truyền thống'],
      openingHours: '7:00 - 19:00',
      price: 0,
    ),

    Attraction(
      id: '77',
      name: 'Chùa cổ Tuyền Lâm',
      address: '887 Hồng Bàng, Phường 9, Quận 6, Hồ Chí Minh',
      description: 'Chùa cổ Tuyền Lâm là công trình kiến trúc tôn giáo lâu đời tại Quận 6.',
      imageUrl: 'assets/images/attractions/chua_tuyen_lam.jpg',
      rating: 4.3,
      location: LatLng(10.7440, 106.6400),
      category: 'religious',
      tags: ['chùa', 'tôn giáo', 'kiến trúc cổ'],
      openingHours: '6:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '78',
      name: 'Chợ đầu mối Bình Điền',
      address: 'Quản Trọng Linh, Phường 7, Bình Chánh, Hồ Chí Minh',
      description: 'Chợ đầu mối lớn chuyên về thực phẩm tươi sống, hoạt động chủ yếu vào ban đêm.',
      imageUrl: 'assets/images/attractions/cho_binh_dien.jpg',
      rating: 4.0,
      location: LatLng(10.7330, 106.6280),
      category: 'shopping',
      tags: ['chợ đầu mối', 'thực phẩm', 'mua sắm'],
      openingHours: '20:00 - 6:00',
      price: 0,
    ),

    Attraction(
      id: '79',
      name: 'Công viên Grand Park',
      address: 'Vinhomes Grand Park, đường Nguyễn Xiển, Phường Long Thạch Mỹ, TP. Thủ Đức, Hồ Chí Minh',
      description: 'Công Viên Grand Park là khu vui chơi mới ở Quận 9 đáng mong chờ khi sẽ mang đến hàng loạt trải nghiệm đỉnh cao. Với tổ hợp công viên nước hiện đại.',
      imageUrl: 'assets/images/attractions/grand_park.jpg',
      rating: 4.6,
      location: LatLng(10.8360, 106.8300),
      category: 'park',
      tags: ['công viên', 'giải trí', 'hiện đại'],
      openingHours: '5:30 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '80',
      name: 'Đầm sen Tam Đa',
      address: '361/20 đường Tam Đa, Phường Trường Thạnh, TP. Thủ Đức, Hồ Chí Minh',
      description: 'Đầm sen Tam Đa là gợi ý lý tưởng cho hoạt động dã ngoại, chụp ảnh và câu cá.',
      imageUrl: 'assets/images/attractions/dam_sen_tam_da.jpg',
      rating: 4.2,
      location: LatLng(10.8400, 106.8350),
      category: 'nature',
      tags: ['đầm sen', 'dã ngoại', 'câu cá'],
      openingHours: '5:00 - 17:00',
      price: 50000,
    ),

    Attraction(
      id: '81',
      name: 'Chùa Bửu Long',
      address: '81 Nguyễn Xiển, Phường Long Bình, TP. Thủ Đức, Hồ Chí Minh',
      description: 'Chùa Bửu Long nằm trong top 10 công trình Phật giáo đẹp nhất thế giới do tạp chí National Geographic bình chọn.',
      imageUrl: 'assets/images/attractions/chua_buu_long.jpg',
      rating: 4.7,
      location: LatLng(10.8420, 106.8400),
      category: 'religious',
      tags: ['chùa', 'phật giáo', 'kiến trúc'],
      openingHours: '7:00 - 17:00',
      price: 0,
    ),

    Attraction(
      id: '82',
      name: 'Đền tưởng niệm Vua Hùng',
      address: 'Công viên Lịch sử Văn hóa Dân Tộc, Phường Long Bình, TP. Thủ Đức, Hồ Chí Minh',
      description: 'Đền tưởng niệm Vua Hùng nằm trên ngọn đồi cao hơn 20m trong Công viên Lịch sử Văn hóa Dân tộc là đền thờ vua Hùng lớn nhất miền Nam.',
      imageUrl: 'assets/images/attractions/den_vua_hung.jpg',
      rating: 4.5,
      location: LatLng(10.8450, 106.8420),
      category: 'religious',
      tags: ['đền', 'lịch sử', 'văn hóa'],
      openingHours: '7:30 - 17:00',
      price: 0,
    ),

    Attraction(
      id: '83',
      name: 'Chùa Châu Đốc 3 (chùa Phước Long)',
      address: 'Cù lao Bà Sang, Phường Long Bình, TP. Thủ Đức, Hồ Chí Minh',
      description: 'Chùa Châu Đốc 3 hay còn gọi chùa Phước Long là công trình tâm linh nổi tiếng nằm trên cù lao giữa sông Đồng Nai.',
      imageUrl: 'assets/images/attractions/chua_chau_doc.jpg',
      rating: 4.4,
      location: LatLng(10.8470, 106.8450),
      category: 'religious',
      tags: ['chùa', 'tâm linh', 'cù lao'],
      openingHours: '6:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '84',
      name: 'Phố đi bộ quận 10',
      address: 'Vòng xoay Kỳ Đài Quang Trung, Phường 6, Quận 10, Hồ Chí Minh',
      description: 'Phố đi bộ quận 10 là không gian dành cho người dân đi bộ và vui chơi giải trí.',
      imageUrl: 'assets/images/attractions/pho_di_bo_q10.jpg',
      rating: 4.2,
      location: LatLng(10.7720, 106.6720),
      category: 'entertainment',
      tags: ['đi bộ', 'giải trí', 'công cộng'],
      openingHours: '18:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '85',
      name: 'Chợ hoa Hồ Thị Kỷ',
      address: 'Hẻm 52 Đường Hồ Thị Kỷ, Phường 1, Quận 10, Hồ Chí Minh',
      description: 'Chợ hoa Hồ Thị Kỷ là một trong những khu chợ chuyên bán hoa có quy mô lớn nhất ở Sài Gòn.',
      imageUrl: 'assets/images/attractions/cho_hoa_ho_thi_ky.jpg',
      rating: 4.3,
      location: LatLng(10.7730, 106.6730),
      category: 'shopping',
      tags: ['chợ hoa', 'mua sắm', 'hoa tươi'],
      openingHours: '4:00 - 10:00',
      price: 0,
    ),

    Attraction(
      id: '86',
      name: 'Chợ đồ cũ Nhật Tảo',
      address: 'Đường Nhật Tảo, Phường 7, Quận 10, Hồ Chí Minh',
      description: 'Nhật Tảo là khu chợ chuyên bán đồ secondhand, rất thích hợp với những bạn thích sưu tầm đồ công nghệ, đồ điện tử giá tốt.',
      imageUrl: 'assets/images/attractions/cho_nhat_tao.jpg',
      rating: 4.1,
      location: LatLng(10.7740, 106.6740),
      category: 'shopping',
      tags: ['đồ cũ', 'công nghệ', 'mua sắm'],
      openingHours: '8:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '87',
      name: 'Khu trưng bày tượng sáp Việt',
      address: '240 Đường 3 Tháng 2, Phường 14, Quận 10, Hồ Chí Minh',
      description: 'Tại đây trưng bày tượng sáp các nghệ sĩ Việt Nam như nhạc sĩ, diễn viên, nghệ sĩ nhân dân… từ cuối thế kỷ XX đến nay.',
      imageUrl: 'assets/images/attractions/tuong_sap_viet.jpg',
      rating: 4.0,
      location: LatLng(10.7750, 106.6750),
      category: 'museum',
      tags: ['tượng sáp', 'nghệ sĩ', 'văn hóa'],
      openingHours: '9:00 - 17:00',
      price: 50000,
    ),

    Attraction(
      id: '88',
      name: 'Karaoke Sư Vạn Hạnh',
      address: 'Đường Sư Vạn Hạnh, Quận 10, Hồ Chí Minh',
      description: 'Sư Vạn Hạnh là con đường cực kỳ sầm uất và nổi tiếng là thiên đường ăn chơi của quận 10.',
      imageUrl: 'assets/images/attractions/su_van_hanh.jpg',
      rating: 4.2,
      location: LatLng(10.7760, 106.6760),
      category: 'nightlife',
      tags: ['karaoke', 'giải trí', 'âm nhạc'],
      openingHours: '18:00 - 2:00',
      price: 0,
    ),

    Attraction(
      id: '89',
      name: 'Bảo tàng y học Việt Nam',
      address: '41 Đường Hoàng Dư Khương, Phường 12, Quận 10, Hồ Chí Minh',
      description: 'Bảo tàng y học Việt Nam sẽ mở ra cho bạn một không gian rất bình yên, tĩnh lặng, chìm trong những mùi hương thoang thoảng của vô số loại thảo mộc.',
      imageUrl: 'assets/images/attractions/bao_tang_y_hoc.jpg',
      rating: 4.4,
      location: LatLng(10.7770, 106.6770),
      category: 'museum',
      tags: ['bảo tàng', 'y học', 'thảo mộc'],
      openingHours: '8:00 - 17:00',
      price: 30000,
    ),

    Attraction(
      id: '90',
      name: 'Việt Nam Quốc Tự',
      address: '244 Đường 3 Tháng 2, Phường 12, Quận 10, Hồ Chí Minh',
      description: 'Ngôi chùa này được xây dựng với phong cách kiến trúc truyền thống, quy mô rất lớn, đặc biệt phải kể đến tòa tháp 13 tầng.',
      imageUrl: 'assets/images/attractions/viet_nam_quoc_tu.jpg',
      rating: 4.5,
      location: LatLng(10.7780, 106.6780),
      category: 'religious',
      tags: ['chùa', 'kiến trúc', 'tháp 13 tầng'],
      openingHours: '6:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '91',
      name: 'Nhà hát Hòa Bình',
      address: '240 Đường 3 Tháng 2, Phường 12, Quận 10, Hồ Chí Minh',
      description: 'Đây là địa điểm thường xuyên tổ chức các buổi biểu diễn chuyên nghiệp, liveshow của những ca sĩ tên tuổi cả trong nước và quốc tế.',
      imageUrl: 'assets/images/attractions/nha_hat_hoa_binh.jpg',
      rating: 4.3,
      location: LatLng(10.7790, 106.6790),
      category: 'entertainment',
      tags: ['nhà hát', 'biểu diễn', 'âm nhạc'],
      openingHours: '19:00 - 22:00',
      price: 200000,
    ),

    Attraction(
      id: '92',
      name: 'Hội An Quán',
      address: '285/94A Hẻm 285 Cách Mạng Tháng Tám, Phường 12, Quận 10, Hồ Chí Minh',
      description: 'Hội An Quán là nhà hàng mang phong cách cổ kính với không gian ấm cúng.',
      imageUrl: 'https://mia.vn/media/uploads/blog-du-lich/quan-10-co-gi-choi-hoi-an-quan-1712072502.jpg',
      rating: 4.2,
      location: LatLng(10.7800, 106.6800),
      category: 'food',
      tags: ['nhà hàng', 'ẩm thực', 'cổ kính'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '93',
      name: 'Bún đậu mắm tôm Tiến Hải',
      address: '409 Đ. Nguyễn Tri Phương, Phường 5, Quận 10, Hồ Chí Minh',
      description: 'Quán bún đậu mắm tôm nổi tiếng với hương vị đậm đà truyền thống.',
      imageUrl: 'assets/images/attractions/bun_dau_tien_hai.jpg',
      rating: 4.1,
      location: LatLng(10.7810, 106.6810),
      category: 'food',
      tags: ['bún đậu', 'ẩm thực', 'truyền thống'],
      openingHours: '16:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '94',
      name: 'Bánh Canh Cua Gia Truyền Cô Dung',
      address: '22 hẻm/269 Đ. Vĩnh Viễn, Phường 5, Quận 10, Hồ Chí Minh',
      description: 'Quán bánh canh cua gia truyền với công thức được truyền qua nhiều thế hệ.',
      imageUrl: 'assets/images/attractions/banh_canh_co_dung.jpg',
      rating: 4.3,
      location: LatLng(10.7820, 106.6820),
      category: 'food',
      tags: ['bánh canh', 'cua', 'gia truyền'],
      openingHours: '6:00 - 14:00',
      price: 0,
    ),

    Attraction(
      id: '95',
      name: 'Bánh tráng cuốn trộn Biển Vương',
      address: 'Chung Cư Ngô Gia Tự, 013 Lô R, Phường 2, Quận 10, Hồ Chí Minh',
      description: 'Quán bánh tráng cuốn trộn với nhiều loại topping hấp dẫn.',
      imageUrl: 'assets/images/attractions/banh_trang_bien_vuong.jpg',
      rating: 4.0,
      location: LatLng(10.7830, 106.6830),
      category: 'food',
      tags: ['bánh tráng', 'ăn vặt', 'trộn'],
      openingHours: '15:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '96',
      name: 'Chè Sinh Viên',
      address: 'Lô R, Phường 2, Quận 10, Hồ Chí Minh',
      description: 'Quán chè nổi tiếng với nhiều loại chè ngon và giá cả phải chăng.',
      imageUrl: 'assets/images/attractions/che_sinh_vien.jpg',
      rating: 4.2,
      location: LatLng(10.7840, 106.6840),
      category: 'food',
      tags: ['chè', 'đồ ngọt', 'sinh viên'],
      openingHours: '14:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '97',
      name: 'Công viên Văn hóa Đầm Sen',
      address: '1A Lạc Long Quân, Phường 5, Quận 11, Hồ Chí Minh',
      description: 'Công viên Văn hóa Đầm Sen là một trong những địa điểm vui chơi vô cùng nổi tiếng ở thành phố Hồ Chí Minh.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114613/cong-vien-van-hoa-dam-sen-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.5,
      location: LatLng(10.7650, 106.6350),
      category: 'park',
      tags: ['công viên', 'giải trí', 'gia đình'],
      openingHours: '8:00 - 18:00',
      price: 80000,
    ),

    Attraction(
      id: '98',
      name: 'Công viên nước Đầm Sen',
      address: '3 Hòa Bình, Phường 3, Quận 11, Hồ Chí Minh',
      description: 'Với 36 trò chơi đa dạng, hấp dẫn, công viên nước Đầm Sen là địa điểm vui chơi lý tưởng cho những nhóm bạn thích trải nghiệm.',
      imageUrl: 'assets/images/attractions/cong_vien_nuoc_dam_sen.jpg',
      rating: 4.4,
      location: LatLng(10.7660, 106.6360),
      category: 'entertainment',
      tags: ['công viên nước', 'trò chơi', 'giải trí'],
      openingHours: '9:00 - 18:00',
      price: 150000,
    ),

    Attraction(
      id: '99',
      name: 'Nhà thi đấu Phú Thọ',
      address: '1 Lữ Gia, Phường 15, Quận 11, Hồ Chí Minh',
      description: 'Nhà thi đấu Phú Thọ là một trong những nhà thi đấu đa năng lớn của thành phố Hồ Chí Minh với sức chứa tối đa lên đến 8.000 người.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114622/nha-thi-dau-phu-tho-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.3,
      location: LatLng(10.7670, 106.6370),
      category: 'sport',
      tags: ['nhà thi đấu', 'thể thao', 'sự kiện'],
      openingHours: '6:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '100',
      name: 'Hồ bơi Phú Thọ',
      address: '215A Lý Thường Kiệt, Phường 15, Quận 11, Hồ Chí Minh',
      description: 'Nằm tại khu vực dân cư đông đúc nên hồ bơi Phú Thọ đã trở thành địa điểm thu hút của nhiều cư dân đến học bơi và tham gia bơi lội.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114615/ho-boi-phu-tho-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.1,
      location: LatLng(10.7680, 106.6380),
      category: 'sport',
      tags: ['hồ bơi', 'thể thao', 'bơi lội'],
      openingHours: '5:30 - 21:00',
      price: 40000,
    ),

    Attraction(
      id: '101',
      name: 'Khánh Vân Nam Viện Đạo quán',
      address: '269/2 Nguyễn Thị Nhỏ, Phường 16, Quận 11, Hồ Chí Minh',
      description: 'Khánh Vân Nam Viện Đạo quán được xây dựng theo lối kiến trúc Trung Quốc và là ngôi đạo quán lớn nhất miền Nam.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114620/khanh-van-nam-vien-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.6,
      location: LatLng(10.7690, 106.6390),
      category: 'religious',
      tags: ['đạo quán', 'kiến trúc', 'tôn giáo'],
      openingHours: '6:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '102',
      name: 'Baoz Dimsum',
      address: '297 – 299 Lê Đại Hành, Phường 13, Quận 11, Hồ Chí Minh',
      description: 'Baoz Dimsum là một trong những thương hiệu cực kỳ nổi tiếng với các món ăn truyền thống của Trung Quốc. Menu với hơn 100 món chắc chắn sẽ chinh phục được khẩu vị của mọi thực khách.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114609/baoz-dimsum-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.4,
      location: LatLng(10.7700, 106.6400),
      category: 'food',
      tags: ['dimsum', 'trung quốc', 'nhà hàng'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '103',
      name: 'Katinat Saigon Kafe',
      address: '8 Lê Đại Hành, Phường 11, Quận 11, Hồ Chí Minh',
      description: 'Katinat Saigon Kafe đã trở thành địa điểm hẹn hò yêu thích của giới trẻ Sài Thành.',
      imageUrl: 'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114617/katinat-quan-11-co-gi-vui-768x512.jpg',
      rating: 4.2,
      location: LatLng(10.7710, 106.6410),
      category: 'food',
      tags: ['cà phê', 'hẹn hò', 'giới trẻ'],
      openingHours: '7:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '104',
      name: 'Khu du lịch Bến Xưa quận 12',
      address: '39A Hà Huy Giáp, Thạnh Lộc, Quận 12, Hồ Chí Minh',
      description: 'Với vị trí đẹp, nằm kế con sông Vàm Thuật, bao quanh là tán cây xanh mướt, không gian nơi đây là điểm thư giãn lý tưởng với những ai tìm kiếm sự yên tĩnh sau những ngày vội vã giữa thành phố xô bồ.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011327232464.jpg',
      rating: 4.3,
      location: LatLng(10.8500, 106.6200),
      category: 'entertainment',
      tags: ['du lịch', 'sông nước', 'thư giãn'],
      openingHours: '7:00 - 21:00',
      price: 328000,
    ),

    Attraction(
      id: '105',
      name: 'Tu viện Khánh An',
      address: '3D Quốc lộ 1A, phường An Phú Đông, Quận 12, Hồ Chí Minh',
      description: 'Được thiết kế theo kiến trúc chùa Nhật Bản vô cùng độc đáo và thú vị, thu hút nhiều khách du lịch ghé thăm.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011328143306.jpg',
      rating: 4.6,
      location: LatLng(10.8510, 106.6210),
      category: 'religious',
      tags: ['tu viện', 'nhật bản', 'kiến trúc'],
      openingHours: '5:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '106',
      name: 'Làng cá sấu',
      address: 'Đường Nguyễn Thị Sáu, Thạnh Lộc, Quận 12, Hồ Chí Minh',
      description: 'Không gian xanh mướt vườn cây đậm chất làng quê Miền Tây, cùng những trang trại nuôi nhốt cá sấu vô cùng thú vị.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011328552278.jpg',
      rating: 4.3,
      location: LatLng(10.8520, 106.6220),
      category: 'entertainment',
      tags: ['cá sấu', 'trang trại', 'miền tây'],
      openingHours: '8:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '107',
      name: 'Khu tưởng niệm Vườn Cau Đỏ',
      address: '12 Thạnh Xuân 52, Thạnh Xuân, Quận 12, Hồ Chí Minh',
      description: 'Khu tưởng niệm Vườn Cau Đỏ được coi là điểm đến tham quan mang đậm giá trị lịch sử kháng chiến giành lại độc lập của dân tộc Việt Nam.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011329272234.jpg',
      rating: 4.2,
      location: LatLng(10.8530, 106.6230),
      category: 'landmark',
      tags: ['tưởng niệm', 'lịch sử', 'kháng chiến'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '108',
      name: 'Moda House Coffee',
      address: 'Quận 12, Hồ Chí Minh',
      description: 'Moda House Coffee là một điểm đến vô cùng lí tưởng với các tín đồ sống ảo và selfie.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011329573450.jpg',
      rating: 4.1,
      location: LatLng(10.8540, 106.6240),
      category: 'food',
      tags: ['cà phê', 'sống ảo', 'selfie'],
      openingHours: '7:00 - 23:30',
      price: 0,
    ),

    Attraction(
      id: '109',
      name: 'Ấm Coffee',
      address: 'Vườn Lài, An Phú Đông, Quận 12, Hồ Chí Minh',
      description: 'Ấm coffee là quán nước được thiết kế theo phong cách vintage đẹp mắt, xung quanh là những dãy đèn, vào buổi tối những ánh đèn lung linh sáng khắp không gian quán tạo một cảm giác vô cùng ấm cúng vào lãng mạng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011330404759.jpg',
      rating: 4.8,
      location: LatLng(10.8550, 106.6250),
      category: 'food',
      tags: ['cà phê', 'vintage', 'lãng mạn'],
      openingHours: '7:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '110',
      name: 'Nông trại Tam Nông',
      address: 'Tổ 33 kp2, Thạnh Xuân, Quận 12, Hồ Chí Minh',
      description: 'Nông trại Tam Nông là địa điểm du lịch làm theo mô hình trang trại nông thuỷ sản.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011331267779.jpg',
      rating: 4.0,
      location: LatLng(10.8560, 106.6260),
      category: 'entertainment',
      tags: ['nông trại', 'thủy sản', 'du lịch'],
      openingHours: '8:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '111',
      name: 'Bún chả Đàm Trang',
      address: '27 Tân Chánh Hiệp 10, quận 12, Hồ Chí Minh',
      description: 'Quán bún chả nổi tiếng với hương vị đậm đà và phục vụ tận tình.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011332126027.jpg',
      rating: 4.2,
      location: LatLng(10.8570, 106.6270),
      category: 'food',
      tags: ['bún chả', 'ẩm thực', 'truyền thống'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '112',
      name: 'Thỏ Sushi quận 12',
      address: 'Quận 12, Hồ Chí Minh',
      description: 'Nhà hàng sushi với không gian hiện đại và món ăn chất lượng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011332255077.jpg',
      rating: 4.3,
      location: LatLng(10.8580, 106.6280),
      category: 'food',
      tags: ['sushi', 'nhật bản', 'hiện đại'],
      openingHours: '11:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '113',
      name: 'Công viên Vinhomes Central Park',
      address: '208 Nguyễn Hữu Cảnh, phường 22, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Khu công viên mang nét đẹp hiện đại, không gian rộng thoáng, nhiều góc sống ảo, nhiều cây xanh, có bãi cỏ rộng để vui chơi.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030818526525.jpg',
      rating: 4.5,
      location: LatLng(10.7950, 106.7200),
      category: 'park',
      tags: ['công viên', 'hiện đại', 'sống ảo'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '114',
      name: 'Ươm Art Hub',
      address: '42/58 Hoàng Hoa Thám, phường 7, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Ươm Art Hub là một khu phức hợp với nhiều khu vực khác nhau như: Studio De Egg, Tiệm sách The Razcals, Design Anthropology School (DAS), Tiệm xăm Tattoonista, quán F&B.',
      imageUrl: 'assets/images/attractions/uom_art_hub.jpg',
      rating: 4.3,
      location: LatLng(10.7960, 106.7210),
      category: 'culture',
      tags: ['nghệ thuật', 'sáng tạo', 'văn hóa'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '115',
      name: 'Văn Thánh',
      address: '48/10 Điện Biên Phủ, phường 22, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Khu du lịch Văn Thánh nằm trong khuôn viên của bán đảo Thanh Đa, là nơi lý tưởng để bạn thư giãn cuối tuần, có đủ hồ bơi, sân tennis, view cafe đẹp tuyệt.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030819571622.jpg',
      rating: 4.2,
      location: LatLng(10.7970, 106.7220),
      category: 'entertainment',
      tags: ['du lịch', 'thư giãn', 'bán đảo'],
      openingHours: '10:00 - 20:00',
      price: 60000,
    ),

    Attraction(
      id: '116',
      name: 'Khu du lịch Tân Cảng',
      address: 'A100 Ung Văn Khiêm, phường 25, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Quán có view sông thoáng mát, đồ ăn khá ổn, phục vụ nhanh. Vừa ăn vừa có thể ngắm tàu chạy, cảm giác thư giãn thoải mái.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030820276672.jpg',
      rating: 4.1,
      location: LatLng(10.7980, 106.7230),
      category: 'entertainment',
      tags: ['du lịch', 'view sông', 'ẩm thực'],
      openingHours: '8:00 - 21:30',
      price: 390000,
    ),

    Attraction(
      id: '117',
      name: 'Khu du lịch Bình Quới 2',
      address: '556 Bình Quới, phường 28, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Khu du lịch sinh thái với không gian xanh mát và nhiều hoạt động giải trí.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030821085287.jpg',
      rating: 4.0,
      location: LatLng(10.7990, 106.7240),
      category: 'entertainment',
      tags: ['du lịch', 'sinh thái', 'giải trí'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '118',
      name: 'Khu du lịch Bình Quới 1',
      address: '1147 Bình Quới, Phường 28, Bình Thạnh, Hồ Chí Minh',
      description: 'Khu du lịch Bình Quới 1 có không gian xanh và có những cảnh đẹp để sống ảo. Đội ngũ phục vụ tại khu vực ẩm thực đặt trước đều tận tình và chu đáo.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030821440327.jpg',
      rating: 3.7,
      location: LatLng(10.8000, 106.7250),
      category: 'entertainment',
      tags: ['du lịch', 'sống ảo', 'ẩm thực'],
      openingHours: '8:00 - 18:00 (T2-T6), 8:00 - 21:00 (T7-CN)',
      price: 130000,
    ),

    Attraction(
      id: '119',
      name: 'Lăng Ông Bà Chiểu',
      address: '01 Vũ Tùng, phường 1, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Lăng Ông Bà Chiểu là lăng thờ Tả Quân Lê Văn Duyệt và thường gọi là Lăng Ông.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030822293369.jpg',
      rating: 4.4,
      location: LatLng(10.8010, 106.7260),
      category: 'landmark',
      tags: ['lăng', 'lịch sử', 'tôn giáo'],
      openingHours: '7:00 - 17:00',
      price: 0,
    ),

    Attraction(
      id: '120',
      name: 'Chợ Bà Chiểu',
      address: 'Đường Bạch Đằng, phường 1, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Chợ Bà Chiểu là khu chợ lâu đời và quen thuộc đối với người dân Sài Gòn. Chợ Bà Chiểu gồm 8 khu chính với hơn 40 ngành hàng khác nhau thuộc 800 hộ kinh doanh.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030822568896.jpg',
      rating: 4.2,
      location: LatLng(10.8020, 106.7270),
      category: 'shopping',
      tags: ['chợ', 'mua sắm', 'truyền thống'],
      openingHours: '5:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '121',
      name: 'JeJu Coffee',
      address: '448 đường Phạm Văn Đồng, phường 13, quận Bình Thạnh, Hồ Chí Minh',
      description: 'JeJu Coffee nổi bật bởi góc sống ảo ở bên ngoài, style Hàn Quốc nên nhìn xinh lắm, bước vô là nguyên 1 khu vườn đầy cây xanh mát, nhiều góc sống ảo nhìn rất đẹp.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030823537578.jpg',
      rating: 4.3,
      location: LatLng(10.8030, 106.7280),
      category: 'food',
      tags: ['cà phê', 'hàn quốc', 'sống ảo'],
      openingHours: '7:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '122',
      name: 'Nhà hàng Phong Cua 2',
      address: '1067 Bình Quới, phường 28, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Nhà hàng Phong Cua 2 được đánh giá cao bởi chất lượng hải sản tươi ngon, đặc biệt là món cua được nhiều thực khách yêu thích.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030824091755.jpg',
      rating: 4.4,
      location: LatLng(10.8040, 106.7290),
      category: 'food',
      tags: ['hải sản', 'cua', 'nhà hàng'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '123',
      name: 'Quán Le Steak',
      address: 'Hẻm 26 đường D5, phường 25, quận Bình Thạnh, Hồ Chí Minh',
      description: 'Quán Le Steak có không gian nhỏ nên các bạn đặt bàn trước để không phải đợi lâu nhé. Chất lượng đồ ăn ổn, giá không quá đắt.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030824371414.jpg',
      rating: 4.2,
      location: LatLng(10.8050, 106.7300),
      category: 'food',
      tags: ['steak', 'âu mỹ', 'nhà hàng'],
      openingHours: '17:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '124',
      name: 'Chợ Hạnh Thông Tây',
      address: '10/2 Quang Trung, Phường 11, quận Gò Vấp, Hồ Chí Minh',
      description: 'Chợ truyền thống với nhiều mặt hàng đa dạng và giá cả phải chăng.',
      imageUrl: 'https://statics.vinpearl.com/quan-go-vap-co-gi-choi-8_1631529140.jpg',
      rating: 4.1,
      location: LatLng(10.8380, 106.6800),
      category: 'shopping',
      tags: ['chợ', 'mua sắm', 'truyền thống'],
      openingHours: '5:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '125',
      name: 'Country House Coffee',
      address: '18C Phan Văn Trị, Phường 10, quận Gò Vấp, Hồ Chí Minh',
      description: 'Quán được ví như Đà Lạt thu nhỏ giữa lòng thành phố.',
      imageUrl: 'https://statics.vinpearl.com/quan-go-vap-co-gi-choi-9_1631529180.jpg',
      rating: 4.4,
      location: LatLng(10.8390, 106.6810),
      category: 'food',
      tags: ['cà phê', 'đà lạt', 'thư giãn'],
      openingHours: '7:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '126',
      name: 'Khu ẩm thực Phan Xích Long',
      address: 'Phan Xích Long, phường 2, quận Phú Nhuận, Hồ Chí Minh',
      description: 'Khu ẩm thực tập trung nhiều quán ăn ngon và đa dạng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030753180957.jpg',
      rating: 4.3,
      location: LatLng(10.7980, 106.6850),
      category: 'food',
      tags: ['ẩm thực', 'đa dạng', 'quán ăn'],
      openingHours: '17:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '127',
      name: 'Nhà thi đấu Quân khu 7',
      address: '202 Hoàng Văn Thụ, Phường 9, Phú Nhuận, Hồ Chí Minh',
      description: 'Nhà thi đấu Quân khu 7 với sức chứa hơn 20.000 người, là nơi tổ chức của nhiều sự kiện lớn - nhỏ trong nước.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030753516841.jpg',
      rating: 4.6,
      location: LatLng(10.7990, 106.6860),
      category: 'sport',
      tags: ['nhà thi đấu', 'sự kiện', 'thể thao'],
      openingHours: '6:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '128',
      name: 'Hồ bơi Rạch Miễu',
      address: '1 Hoa Phượng, Phường 2, Phú Nhuận, Hồ Chí Minh',
      description: 'Hồ bơi Rạch Miễu là một trong những địa điểm bơi lội cực chất ở thành phố Hồ Chí Minh.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030754233325.jpg',
      rating: 4.1,
      location: LatLng(10.8000, 106.6870),
      category: 'sport',
      tags: ['hồ bơi', 'bơi lội', 'thể thao'],
      openingHours: '13:30 - 15:15, 15:30 - 17:15, 17:30 - 19:00',
      price: 25000,
    ),

    Attraction(
      id: '129',
      name: 'Cơm tấm Ba Ghiền',
      address: '84 Đặng Văn Ngữ, phường 10, quận Phú Nhuận, Hồ Chí Minh',
      description: 'Cơm tấm Ba Ghiền với nhiều món ăn kèm vô cùng thơm ngon, mới lạ.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755199443.jpg',
      rating: 4.3,
      location: LatLng(10.8010, 106.6880),
      category: 'food',
      tags: ['cơm tấm', 'ẩm thực', 'truyền thống'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '130',
      name: 'Bún riêu hẻm Ông Tiên',
      address: 'Hẻm 96 Phan Đình Phùng, Phường 2, Phú Nhuận, Hồ Chí Minh',
      description: 'Quán bún riêu nổi tiếng với hương vị đậm đà và không gian ấm cúng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755332363.jpg',
      rating: 4.2,
      location: LatLng(10.8020, 106.6890),
      category: 'food',
      tags: ['bún riêu', 'ẩm thực', 'hẻm'],
      openingHours: '6:00 - 14:00',
      price: 0,
    ),

    Attraction(
      id: '131',
      name: 'Phở Hoa Bắc',
      address: '50F2 Đường Hoa Cau, Phường 7, Phú Nhuận, Hồ Chí Minh',
      description: 'Quán phở truyền thống với hương vị Bắc đậm đà.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755472457.jpg',
      rating: 4.4,
      location: LatLng(10.8030, 106.6900),
      category: 'food',
      tags: ['phở', 'bắc', 'truyền thống'],
      openingHours: '6:00 - 14:00, 17:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '132',
      name: 'Ốc luộc Huỳnh Văn Bánh',
      address: '533/59 Huỳnh Văn Bánh, Phường 14, Phú Nhuận, Hồ Chí Minh',
      description: 'Quán ốc luộc nổi tiếng với nhiều loại ốc tươi ngon.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030756035333.jpg',
      rating: 4.1,
      location: LatLng(10.8040, 106.6910),
      category: 'food',
      tags: ['ốc', 'hải sản', 'ăn vặt'],
      openingHours: '16:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '133',
      name: 'Công viên Hoàng Văn Thụ',
      address: 'Hoàng Văn Thụ, Phường 2, Tân Bình, Hồ Chí Minh',
      description: 'Được mệnh danh là lá phổi xanh của thành phố, công viên Hoàng Văn Thụ là địa điểm đi chơi ở quận Tân Bình được nhiều người yêu thích với diện tích 106.500m2.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040014024466.jpg',
      rating: 4.4,
      location: LatLng(10.7990, 106.6540),
      category: 'park',
      tags: ['công viên', 'lá phổi xanh', 'thể thao'],
      openingHours: '7:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '134',
      name: 'Chùa Viên Giác',
      address: '193 Bùi Thị Xuân, Phường 1, Tân Bình, Hồ Chí Minh',
      description: 'Chùa Viên Giác hiện tọa lạc tại tại số 193 Bùi Thị Xuân - Quận Tân Bình mang lại cảm giác an lạc thanh tịnh trong kiến trúc Phật giáo cổ kính uy nghiêm.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040014356517.jpg',
      rating: 4.7,
      location: LatLng(10.8000, 106.6550),
      category: 'religious',
      tags: ['chùa', 'phật giáo', 'kiến trúc cổ'],
      openingHours: '6:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '135',
      name: 'Chùa Phổ Quang',
      address: '21 Huỳnh Lan Khanh, Phường 2, Tân Bình, Hồ Chí Minh',
      description: 'Chùa Phổ Quang tọa lạc tại 64 Huỳnh Lan Khanh, Phường 2, quận Tân Bình. Đây là ngôi chùa nổi tiếng với bề dày lịch sử được nhiều người dân Sài Gòn lui đến.',
      imageUrl: 'assets/images/attractions/chua_pho_quang.jpg',
      rating: 4.6,
      location: LatLng(10.8010, 106.6560),
      category: 'religious',
      tags: ['chùa', 'lịch sử', 'tôn giáo'],
      openingHours: '6:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '136',
      name: 'CGV Trường Sơn (CGV CT Plaza)',
      address: '60A Trường Sơn, Phường 2, Tân Bình, Hồ Chí Minh',
      description: 'CGV Trường Sơn (CGV CT Plaza) là một trong những cụm rạp chiếu phim được nhiều người ưa chuộng nhất tại Việt Nam.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040017147849.jpg',
      rating: 4.2,
      location: LatLng(10.8020, 106.6570),
      category: 'entertainment',
      tags: ['rạp phim', 'giải trí', 'cgv'],
      openingHours: '9:00 - 21:00',
      price: 120000,
    ),

    Attraction(
      id: '137',
      name: 'Tiệm cà phê Hiên Cúc Trắng',
      address: '25 Tân Canh, Phường 1, Tân Bình, Hồ Chí Minh',
      description: 'Hiên Cúc Trắng là một trong những quán cà phê mang đậm sắc tố hoài cổ, mông mơ và yên bình.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040017529003.jpg',
      rating: 4.3,
      location: LatLng(10.8030, 106.6580),
      category: 'food',
      tags: ['cà phê', 'hoài cổ', 'yên bình'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '138',
      name: 'Chùa Giác Lâm',
      address: '565 Lạc Long Quân, Phường 10, Tân Bình, Hồ Chí Minh',
      description: 'Chùa Giác Lâm (tổ đình Giác Lâm) là một trong những ngôi chùa có lịch sử lâu đời với hơn 300 năm tuổi.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040018317511.jpg',
      rating: 4.6,
      location: LatLng(10.8040, 106.6590),
      category: 'religious',
      tags: ['chùa', 'lịch sử', '300 năm'],
      openingHours: '5:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '139',
      name: 'Công viên Tân Phước',
      address: '9A1 Nguyễn Thị Nhỏ, Phường 9, Tân Bình, Hồ Chí Minh',
      description: 'Công viên Tân Phước là một trong những công viên lâu đời tại quận Tân Bình.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040019055083.jpg',
      rating: 4.1,
      location: LatLng(10.8050, 106.6600),
      category: 'park',
      tags: ['công viên', 'lâu đời', 'thư giãn'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '140',
      name: 'Bảo Tàng Không Quân Phía Nam',
      address: '87 Thăng Long, Phường 4, Tân Bình, Hồ Chí Minh',
      description: 'Nơi đây lưu giữ nhiều hiện vật, tài liệu về cuộc kháng chiến chống thực dân và đế quốc xâm lược.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040019392677.jpg',
      rating: 4.1,
      location: LatLng(10.8060, 106.6610),
      category: 'museum',
      tags: ['bảo tàng', 'không quân', 'lịch sử'],
      openingHours: '7:30 - 15:30',
      price: 0,
    ),

    Attraction(
      id: '141',
      name: 'Vincom Plaza Cộng Hoà',
      address: '17 Đ. Cộng Hòa, Phường 4, Tân Bình, Hồ Chí Minh',
      description: 'Vincom Plaza Cộng Hòa được thiết lập với những chuẩn mực mới về sự tiện lợi.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040020172163.jpg',
      rating: 4.0,
      location: LatLng(10.8070, 106.6620),
      category: 'shopping',
      tags: ['trung tâm thương mại', 'mua sắm', 'tiện lợi'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '142',
      name: 'Bảo tàng Lực lượng Vũ trang Miền Đông Nam Bộ',
      address: '247 Hoàng Văn Thụ, Phường 1, Tân Bình, Hồ Chí Minh',
      description: 'Bảo tàng Lực lượng Vũ trang Miền Đông Nam Bộ có nhiều hiện vật lịch sử các thời kỳ kháng chiến chống Pháp - Mỹ.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040020595161.jpg',
      rating: 4.1,
      location: LatLng(10.8080, 106.6630),
      category: 'museum',
      tags: ['bảo tàng', 'vũ trang', 'kháng chiến'],
      openingHours: '7:00 - 16:30',
      price: 0,
    ),

    Attraction(
      id: '143',
      name: 'Kimbap Hoàng tử',
      address: '337/2 Đ. Lê Văn Sỹ, Phường 1, Tân Bình, Hồ Chí Minh',
      description: 'Nhà hàng Hàn Quốc chuyên về kimbap và các món ăn truyền thống.',
      imageUrl: 'assets/images/attractions/kimbap_hoang_tu.jpg',
      rating: 4.2,
      location: LatLng(10.8090, 106.6640),
      category: 'food',
      tags: ['kimbap', 'hàn quốc', 'nhà hàng'],
      openingHours: '10:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '144',
      name: 'Moon Fast Food',
      address: '53 Xuân Hồng, phường 4, quận Tân Bình, Hồ Chí Minh',
      description: 'Chuỗi thức ăn nhanh với nhiều món ăn đa dạng và giá cả phải chăng.',
      imageUrl: 'assets/images/attractions/moon_fast_food.jpg',
      rating: 4.0,
      location: LatLng(10.8100, 106.6650),
      category: 'food',
      tags: ['fast food', 'thức ăn nhanh', 'giá rẻ'],
      openingHours: '9:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '145',
      name: 'Mì gà quay San San',
      address: '1235 Hoàng Sa, Phường 5, Tân Bình, Hồ Chí Minh',
      description: 'Quán mì gà quay nổi tiếng với hương vị đặc trưng và giá cả hợp lý.',
      imageUrl: 'assets/images/attractions/mi_ga_quay_san_san.jpg',
      rating: 4.3,
      location: LatLng(10.8110, 106.6660),
      category: 'food',
      tags: ['mì gà quay', 'ẩm thực', 'đặc sản'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '146',
      name: 'Cháo sườn Ông Tạ',
      address: '402 Phạm Văn Hai, phường 5, quận Tân Bình, Hồ Chí Minh',
      description: 'Quán cháo sườn truyền thống với hương vị đậm đà và phục vụ tận tình.',
      imageUrl: 'assets/images/attractions/chao_suon_ong_ta.jpg',
      rating: 4.2,
      location: LatLng(10.8120, 106.6670),
      category: 'food',
      tags: ['cháo sườn', 'truyền thống', 'ẩm thực'],
      openingHours: '6:00 - 14:00',
      price: 0,
    ),

    Attraction(
      id: '147',
      name: 'Heart Kitchen',
      address: '234 Đồng Đen, Phường 14, Tân Bình, Hồ Chí Minh',
      description: 'Nhà hàng với không gian ấm cúng và thực đơn đa dạng.',
      imageUrl: 'assets/images/attractions/heart_kitchen.jpg',
      rating: 4.1,
      location: LatLng(10.8130, 106.6680),
      category: 'food',
      tags: ['nhà hàng', 'ấm cúng', 'đa dạng'],
      openingHours: '11:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '148',
      name: 'Aeon Mall Tân Phú',
      address: '30 Bờ Bao Tân Thắng, Sơn Kỳ, Tân Phú, Hồ Chí Minh',
      description: 'Trung tâm thương mại lớn với nhiều thương hiệu nổi tiếng và khu vui chơi giải trí.',
      imageUrl: 'assets/images/attractions/aeon_mall_tan_phu.jpg',
      rating: 4.4,
      location: LatLng(10.7800, 106.6200),
      category: 'shopping',
      tags: ['aeon mall', 'mua sắm', 'giải trí'],
      openingHours: '9:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '149',
      name: 'Galaxy Trường Chinh',
      address: 'Co.opMart TTTM Thắng Lợi, 2 Đ. Trường Chinh, Tân Phú, Hồ Chí Minh',
      description: 'Rạp chiếu phim hiện đại với công nghệ âm thanh và hình ảnh chất lượng cao.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/2b592dbf-tan-phu-co-gi-choi-3.jpg',
      rating: 4.2,
      location: LatLng(10.7810, 106.6210),
      category: 'entertainment',
      tags: ['rạp phim', 'galaxy', 'giải trí'],
      openingHours: '8:00 - 23:00',
      price: 90000,
    ),

    Attraction(
      id: '150',
      name: 'Starbucks Pandora City',
      address: 'Số 1, Đ. Trường Chinh, Phường 15, Tân Phú, Hồ Chí Minh',
      description: 'Cửa hàng Starbucks với không gian hiện đại và menu đồ uống phong phú.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/39e9e5da-tan-phu-co-gi-choi-5.jpg',
      rating: 4.3,
      location: LatLng(10.7820, 106.6220),
      category: 'food',
      tags: ['starbucks', 'cà phê', 'hiện đại'],
      openingHours: '7:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '151',
      name: 'Công viên Celadon City',
      address: 'số 88, Đ. N1, phường Sơn Kỳ, quận Tân Phú, Hồ Chí Minh',
      description: 'Công viên Celadon City là một trong những mảng xanh hiếm hoi tại Tân Phú, nơi lý tưởng để thư giãn hoặc tham gia các hoạt động ngoài trời.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/8feeefef-tan-phu-co-gi-choi-6.jpg',
      rating: 4.2,
      location: LatLng(10.7830, 106.6230),
      category: 'park',
      tags: ['công viên', 'mảng xanh', 'ngoài trời'],
      openingHours: '5:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '152',
      name: 'Chùa Pháp Vân',
      address: 'số 16 Đ. Lê Thúc Hoạch, Phú Thọ Hoà, Tân Phú, Hồ Chí Minh',
      description: 'Tọa lạc tại quận Tân Phú, Chùa Pháp Vân là điểm đến bình yên dành cho những ai muốn tìm kiếm sự tĩnh lặng giữa nhịp sống đô thị.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/f70e8f23-tan-phu-co-gi-choi-7.jpg',
      rating: 4.5,
      location: LatLng(10.7840, 106.6240),
      category: 'religious',
      tags: ['chùa', 'bình yên', 'tĩnh lặng'],
      openingHours: '6:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '153',
      name: 'Khu vui chơi Top World Tân Phú',
      address: 'số 685 Đ. Âu Cơ, Tân Thành, Tân Phú, Hồ Chí Minh',
      description: 'Khu vui chơi giải trí với nhiều trò chơi hấp dẫn dành cho mọi lứa tuổi.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/00ecff67-tan-phu-co-gi-choi-8.jpg',
      rating: 4.1,
      location: LatLng(10.7850, 106.6250),
      category: 'entertainment',
      tags: ['vui chơi', 'trò chơi', 'gia đình'],
      openingHours: '0:00 - 21:30',
      price: 125000,
    ),

    Attraction(
      id: '154',
      name: 'Bánh Ép Huế Thi Thi',
      address: 'Số 49 Đ. Tân Thắng, P. Sơn Kỳ, Q. Tân Phú, Hồ Chí Minh',
      description: 'Bánh Ép Huế Thi Thi là địa điểm ăn vặt quen thuộc của giới trẻ tại Tân Phú.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/31f27ad9-tan-phu-co-gi-choi-9.jpg',
      rating: 4.2,
      location: LatLng(10.7860, 106.6260),
      category: 'food',
      tags: ['bánh ép huế', 'ăn vặt', 'giới trẻ'],
      openingHours: '15:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '155',
      name: 'Chiang Rai Tân Phú',
      address: '710/5 Đ. Lũy Bán Bích, Tân Thành, Tân Phú, Hồ Chí Minh',
      description: 'Đây là điểm đến lý tưởng cho những tín đồ ẩm thực Thái Lan.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/0c3bd80b-tan-phu-co-gi-choi-10.jpg',
      rating: 4.3,
      location: LatLng(10.7870, 106.6270),
      category: 'food',
      tags: ['thái lan', 'ẩm thực', 'nhà hàng'],
      openingHours: '10:30 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '156',
      name: 'Soul-in Rooftop Tân Phú',
      address: 'số 149 Đ. Độc Lập, Tân Quý, Tân Phú, Hồ Chí Minh',
      description: 'Quán rooftop với view đẹp và không gian lãng mạn.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/d6043604-tan-phu-co-gi-choi-11.jpg',
      rating: 4.4,
      location: LatLng(10.7880, 106.6280),
      category: 'nightlife',
      tags: ['rooftop', 'view đẹp', 'lãng mạn'],
      openingHours: '17:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '157',
      name: 'Bake rooftop',
      address: '281 Tây Thạnh, Tân Phú, Hồ Chí Minh',
      description: 'Quán rooftop với không gian thoáng đãng và thức uống đa dạng.',
      imageUrl: 'https://cdn.xanhsm.com/2024/12/1135babd-tan-phu-co-gi-choi-12.jpg',
      rating: 4.2,
      location: LatLng(10.7890, 106.6290),
      category: 'nightlife',
      tags: ['rooftop', 'thoáng đãng', 'thức uống'],
      openingHours: '17:00 - 00:30',
      price: 0,
    ),

    Attraction(
      id: '158',
      name: 'Công viên Gia Phú',
      address: 'Đường CN1, Sơn Kỳ, Bình Tân, Hồ Chí Minh',
      description: 'Công viên Gia Phú là địa điểm lý tưởng cho bạn khi muốn tìm kiếm nơi có không gian trong lành.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041513168861.jpg',
      rating: 4.2,
      location: LatLng(10.7400, 106.6100),
      category: 'park',
      tags: ['công viên', 'không gian trong lành', 'thư giãn'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '159',
      name: 'Chùa Huệ Nghiêm',
      address: 'KP2 Đỗ Năng Tế, An Lạc A, Bình Tân, Hồ Chí Minh',
      description: 'Ngôi chùa được mệnh danh là chốn "bồng lai tiên cảnh" giữa lòng đô thị.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041513572434.jpg',
      rating: 4.7,
      location: LatLng(10.7410, 106.6110),
      category: 'religious',
      tags: ['chùa', 'bồng lai tiên cảnh', 'tôn giáo'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '160',
      name: 'Hồ câu Út Phương',
      address: '78b kênh số 1, Tân Tạo A, Bình Tân, Hồ Chí Minh',
      description: 'Hồ câu Út Phương là địa điểm giải trí vô cùng thích hợp dành cho những cánh mày râu muốn trải nghiệm cảm giác câu cá đồng quê chân thực.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041514387127.jpg',
      rating: 3.8,
      location: LatLng(10.7420, 106.6120),
      category: 'entertainment',
      tags: ['hồ câu', 'câu cá', 'đồng quê'],
      openingHours: '24/7',
      price: 150000,
    ),

    Attraction(
      id: '161',
      name: 'King Koi Coffee',
      address: '118 đường số 7, Bình Trị Đông B, Bình Tân, Hồ Chí Minh',
      description: 'Một trong những địa điểm vui chơi và thư giãn sở hữu không gian vô cùng đẹp mắt với các hồ cá koi sinh động.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041515508372.jpg',
      rating: 4.1,
      location: LatLng(10.7430, 106.6130),
      category: 'food',
      tags: ['cà phê', 'cá koi', 'thư giãn'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '162',
      name: 'Chùa Từ Hạnh',
      address: '574 Kinh Dương Vương, An Lạc, Bình Tân, Hồ Chí Minh',
      description: 'Chùa Từ Hạnh là ngôi chùa có kiến trúc đẹp và không gian tĩnh lặng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041516367716.jpg',
      rating: 4.6,
      location: LatLng(10.7440, 106.6140),
      category: 'religious',
      tags: ['chùa', 'kiến trúc', 'tĩnh lặng'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '163',
      name: 'Big C An Lạc',
      address: '1231 QL1A, khu Phố 5, Bình Tân, Hồ Chí Minh',
      description: 'Big C An Lạc là trung tâm thương mại, vui chơi giải trí lớn nhất nhì quận Bình Tân.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041517448982.jpg',
      rating: 4.5,
      location: LatLng(10.7450, 106.6150),
      category: 'shopping',
      tags: ['big c', 'trung tâm thương mại', 'mua sắm'],
      openingHours: '8:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '164',
      name: 'Chợ An Lạc',
      address: '357 Kinh Dương Vương, An Lạc, Bình Tân, Hồ Chí Minh',
      description: 'Là ngôi chợ lâu đời và tấp nập hàng đầu ở quận Bình Tân.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041518150732.jpg',
      rating: 4.0,
      location: LatLng(10.7460, 106.6160),
      category: 'shopping',
      tags: ['chợ', 'lâu đời', 'tấp nập'],
      openingHours: '5:00 - 20:00',
      price: 0,
    ),

    Attraction(
      id: '165',
      name: 'Quán Ăn Long Ký',
      address: '124 đường Số 1, Bình Trị Đông B, Bình Tân, Hồ Chí Minh',
      description: 'Quán ăn gia đình với nhiều món ăn ngon và giá cả phải chăng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041518498251.jpg',
      rating: 4.1,
      location: LatLng(10.7470, 106.6170),
      category: 'food',
      tags: ['quán ăn', 'gia đình', 'giá rẻ'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '166',
      name: 'Cơm Niêu Thiên Lý',
      address: '120 đường số 7, Bình Trị Đông B, Bình Tân, Hồ Chí Minh',
      description: 'Nhà hàng chuyên về cơm niêu với hương vị truyền thống.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519047989.jpg',
      rating: 4.2,
      location: LatLng(10.7480, 106.6180),
      category: 'food',
      tags: ['cơm niêu', 'truyền thống', 'nhà hàng'],
      openingHours: '11:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '167',
      name: 'Lẩu Bò Tư Công Viên',
      address: '204 Tên Lửa, Bình Trị Đông B, Bình Tân, Hồ Chí Minh',
      description: 'Nhà hàng lẩu bò nổi tiếng với chất lượng thịt tươi ngon.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519236554.jpg',
      rating: 4.3,
      location: LatLng(10.7490, 106.6190),
      category: 'food',
      tags: ['lẩu bò', 'thịt tươi', 'nhà hàng'],
      openingHours: '16:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '168',
      name: 'Ăn vặt Nhím Nhím',
      address: '52 đường số 19, Bình Trị Đông B, Bình Tân, Hồ Chí Minh',
      description: 'Quán ăn vặt với nhiều món ngon và không gian vui nhộn.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519462312.jpg',
      rating: 4.0,
      location: LatLng(10.7500, 106.6200),
      category: 'food',
      tags: ['ăn vặt', 'vui nhộn', 'giới trẻ'],
      openingHours: '15:00 - 23:00',
      price: 0,
    ),

    Attraction(
      id: '169',
      name: 'Khu du lịch văn hóa Suối Tiên',
      address: '120 Xa Lộ Hà Nội, TP Thủ Đức, Hồ Chí Minh',
      description: 'Các khu vực trong công viên có kiến trúc và thiết kế được lấy cảm hứng từ những câu chuyện nổi tiếng như Sơn Tinh - Thủy Tinh, Vua Hùng, Âu Cơ - Lạc Long Quân.',
      imageUrl: 'https://statics.vinpearl.com/Khu-du-lich-van-hoa-suoi-tien_1729842968.jpg',
      rating: 4.6,
      location: LatLng(10.8800, 106.8000),
      category: 'entertainment',
      tags: ['suối tiên', 'văn hóa', 'trò chơi'],
      openingHours: '8:00 - 18:00',
      price: 640000,
    ),

    Attraction(
      id: '170',
      name: 'Khu du lịch sinh thái Song Long',
      address: 'số 10 đường D1, Long Phước, TP Thủ Đức, Hồ Chí Minh',
      description: 'Khu du lịch Song Long có không gian sông nước dân dã, gần gũi phù hợp có những ai muốn trải nghiệm không gian trong lành, tránh xa sự ồn ào và hối hả của phố thị.',
      imageUrl: 'https://statics.vinpearl.com/khu-du-lich-sinh-thai-song-long_1729842996.jpg',
      rating: 4.2,
      location: LatLng(10.8810, 106.8010),
      category: 'entertainment',
      tags: ['sinh thái', 'sông nước', 'dân dã'],
      openingHours: '8:00 - 17:00 (T7, CN)',
      price: 90000,
    ),

    Attraction(
      id: '171',
      name: 'Khu du lịch sinh thái Long Phước',
      address: '327 đường số 5, khu phố Lân Ngoài, TP Thủ Đức, Hồ Chí Minh',
      description: 'Khu du lịch sinh thái Long Phước Quận 9 nằm cạnh bờ sông, mang đến cho du khách một không gian miệt vườn xanh mát.',
      imageUrl: 'https://statics.vinpearl.com/Khu-du-lich-sinh-thai-Long-Phuoc_1729843076.jpg',
      rating: 4.1,
      location: LatLng(10.8820, 106.8020),
      category: 'entertainment',
      tags: ['sinh thái', 'miệt vườn', 'bờ sông'],
      openingHours: '8:00 - 17:00',
      price: 80000,
    ),

    Attraction(
      id: '172',
      name: 'Vincom Mega Mall Grand Park',
      address: 'đường Nguyễn Xiển, Long Bình, Tp Thủ Đức, Hồ Chí Minh',
      description: 'Vincom Mega Mall Grand Park có diện tích rộng lớn với hơn 50.000m², quy tụ hơn 140 thương hiệu nổi tiếng trong nước và quốc tế.',
      imageUrl: 'https://statics.vinpearl.com/Vincom-Mega-Mall-Grand-Park_1729843175.jpg',
      rating: 4.5,
      location: LatLng(10.8830, 106.8030),
      category: 'shopping',
      tags: ['vincom', 'mega mall', 'thương hiệu'],
      openingHours: '9:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '173',
      name: 'Công viên hầm Thủ Thiêm',
      address: 'Thủ Thiêm, TP Thủ Đức, Hồ Chí Minh',
      description: 'Công viên hầm Thủ Thiêm là không gian xanh độc đáo nằm dưới lòng đất.',
      imageUrl: 'https://statics.vinpearl.com/ham-thu-thiem-sai-gon_1729843239.jpg',
      rating: 4.3,
      location: LatLng(10.8840, 106.8040),
      category: 'park',
      tags: ['công viên', 'hầm', 'độc đáo'],
      openingHours: '6:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '174',
      name: 'Phố Nhật Bản Oishi Town',
      address: '28 Thảo Điền, TP Thủ Đức, Hồ Chí Minh',
      description: 'Nơi đây giống như một "Nhật Bản thu nhỏ" với không gian được bố trí đậm chất xứ phù tang.',
      imageUrl: 'https://statics.vinpearl.com/pho-nhat-oishi-town_1729843310.jpg',
      rating: 4.4,
      location: LatLng(10.8850, 106.8050),
      category: 'culture',
      tags: ['nhật bản', 'văn hóa', 'ẩm thực'],
      openingHours: '9:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '175',
      name: 'Chùa Một Cột Thủ Đức',
      address: '100 Đặng Văn Bi, Bình Thọ, TP Thủ Đức, Hồ Chí Minh',
      description: 'Công trình kiến trúc Phật giáo độc đáo này được xây dựng mô phỏng theo kiến trúc Diên Hựu Tự ở thế kỷ XI.',
      imageUrl: 'https://statics.vinpearl.com/chua-mot-cot-thu-duc_1729843331.jpg',
      rating: 4.5,
      location: LatLng(10.8860, 106.8060),
      category: 'religious',
      tags: ['chùa', 'một cột', 'kiến trúc'],
      openingHours: '6:00 - 18:00',
      price: 0,
    ),

    Attraction(
      id: '176',
      name: 'Lâu đài Long Island',
      address: '173 Long Thuận, Long Phước, TP Thủ Đức, Hồ Chí Minh',
      description: 'Lâu đài Long Island được xây dựng trên diện tích rộng 5h, mô phỏng theo kiến trúc cổ kính châu Âu.',
      imageUrl: 'https://statics.vinpearl.com/lau-dai-long-island-quan-9_1729843350.jpg',
      rating: 4.2,
      location: LatLng(10.8870, 106.8070),
      category: 'landmark',
      tags: ['lâu đài', 'châu âu', 'kiến trúc'],
      openingHours: '8:00 - 17:00',
      price: 100000,
    ),

    Attraction(
      id: '177',
      name: 'Vietgangz Glamping Club',
      address: '169 đường số 5, Long Phước, TP Thủ Đức, Hồ Chí Minh',
      description: 'Nơi đây thích hợp để du khách tìm đến picnic, thư giãn.',
      imageUrl: 'https://statics.vinpearl.com/khu-cam-trai-vietgangz-glamping-club-saigon_1729843391.jpg',
      rating: 4.1,
      location: LatLng(10.8880, 106.8080),
      category: 'entertainment',
      tags: ['glamping', 'picnic', 'thư giãn'],
      openingHours: '8:00 - 22:00',
      price: 200000,
    ),

    Attraction(
      id: '178',
      name: 'Asia Island Glamping',
      address: '195 đường số 5, Long Phước, TP Thủ Đức, Hồ Chí Minh',
      description: 'Asia Island Glamping là khu cắm trại nằm bên sông Sài Gòn, có hệ thống lều trại đầy đủ tiện nghi mang đến cho du khách cảm giác thoải nhưng vẫn gần gần gũi với thiên nhiên.',
      imageUrl: 'https://statics.vinpearl.com/nuong-bbq-tai-asia-islan-glamping_1729843412.jpg',
      rating: 4.3,
      location: LatLng(10.8890, 106.8090),
      category: 'entertainment',
      tags: ['glamping', 'sông sài gòn', 'thiên nhiên'],
      openingHours: '8:00 - 22:00',
      price: 250000,
    ),

    Attraction(
      id: '179',
      name: 'Rio Glamping',
      address: '35 đường số 5, Long Phước, TP Thủ Đức, Hồ Chí Minh',
      description: 'Tham gia các trò chơi: chèo thuyền kayak, bóng rổ, bắn cung, câu cá, đốt lửa trại, tổ chức nướng BBQ, check in không gian đẹp…',
      imageUrl: 'https://statics.vinpearl.com/Rio-Glamping_1729843433.jpg',
      rating: 4.2,
      location: LatLng(10.8900, 106.8100),
      category: 'entertainment',
      tags: ['glamping', 'trò chơi', 'bbq'],
      openingHours: '8:00 - 22:00',
      price: 220000,
    ),

    Attraction(
      id: '180',
      name: 'Cafe Thủy Trúc 1982',
      address: 'Đường Số 2, Khu Dân Cư Phú Xuân, Nhà Bè, Hồ Chí Minh',
      description: 'Cafe Thủy Trúc 1982 là dạng quán cafe sân vườn rất được nhiều khách hàng ghé thăm, quán có không gian rộng rãi, thức uống đa dạng và nhân viên phục vụ tận tình, giá cả lại rẻ.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030837358919.jpg',
      rating: 4.1,
      location: LatLng(10.6800, 106.7500),
      category: 'food',
      tags: ['cafe', 'sân vườn', 'giá rẻ'],
      openingHours: '6:15 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '181',
      name: 'Bến Xưa Cafe - The Old Dock Coffee & Tea',
      address: 'Đường 12, Vạn Hưng Phú, Khu Dân Cư Phú Xuân, Nhà Bè, Hồ Chí Minh',
      description: 'Bến Xưa Cafe - The Old Dock Coffee & Tea là quán cafe sân vườn theo phong cách cổ điển, làng quê rất đặc biệt.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030840086667.jpg',
      rating: 4.6,
      location: LatLng(10.6810, 106.7510),
      category: 'food',
      tags: ['cafe', 'cổ điển', 'làng quê'],
      openingHours: '6:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '182',
      name: 'Bún bò Huế O Diện',
      address: 'Nhà Bè, Hồ Chí Minh',
      description: 'Quán bún bò Huế nổi tiếng với hương vị đậm đà và chính hiệu.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030841182370.jpg',
      rating: 4.2,
      location: LatLng(10.6820, 106.7520),
      category: 'food',
      tags: ['bún bò huế', 'đậm đà', 'chính hiệu'],
      openingHours: '6:00 - 14:00',
      price: 0,
    ),

    Attraction(
      id: '183',
      name: 'Cơm tấm đêm Ba Trang',
      address: 'Nhà Bè, Hồ Chí Minh',
      description: 'Cơm tấm đêm Ba Trang với những phần cơm tấm hấp dẫn, ngoài sườn bì chả, trứng ra thì còn có những món ăn khác cùng đồ chua đa dạng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030841295618.jpg',
      rating: 4.1,
      location: LatLng(10.6830, 106.7530),
      category: 'food',
      tags: ['cơm tấm', 'đêm', 'đa dạng'],
      openingHours: '18:00 - 2:00',
      price: 0,
    ),

    Attraction(
      id: '184',
      name: 'Chùa Pháp Bửu',
      address: '1 Bùi Công Trừng, Đông Thạnh, Hóc Môn, Hồ Chí Minh',
      description: 'Chùa Pháp Bửu là ngôi chùa có kiến trúc đẹp và không gian tâm linh tĩnh lặng.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031143441293.jpg',
      rating: 4.6,
      location: LatLng(10.8600, 106.5900),
      category: 'religious',
      tags: ['chùa', 'kiến trúc', 'tâm linh'],
      openingHours: '24/7',
      price: 0,
    ),

    Attraction(
      id: '185',
      name: 'Khu du lịch Villa H2O',
      address: '4C Đ. Đặng Thúc Vịnh, Ấp 3, Hóc Môn, Hồ Chí Minh',
      description: 'Khu du lịch Villa H2O với không gian nghỉ dưỡng và nhiều tiện ích giải trí.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031144146801.jpg',
      rating: 3.9,
      location: LatLng(10.8610, 106.5910),
      category: 'entertainment',
      tags: ['villa', 'nghỉ dưỡng', 'giải trí'],
      openingHours: '8:00 - 21:00',
      price: 800000,
    ),

    Attraction(
      id: '186',
      name: 'Khu di tích Ngã Ba Giồng',
      address: '1 Phan Văn Hớn, Xuân Thới Thượng, Hóc Môn, Hồ Chí Minh',
      description: 'Khu di tích Ngã Ba Giồng là một địa điểm lý tưởng giúp bạn có thể vừa khám phá vừa có thể học hỏi được những kiến thức lịch sử hữu ích.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031144401567.jpg',
      rating: 4.6,
      location: LatLng(10.8620, 106.5920),
      category: 'landmark',
      tags: ['di tích', 'lịch sử', 'giáo dục'],
      openingHours: '7:30 - 17:00',
      price: 0,
    ),

    Attraction(
      id: '187',
      name: 'Công Viên Cá Koi RinRin Park',
      address: '87/8p Xuân Thới Thượng, 6 Ấp Xuân Thới Đông, Xuân Thới Đông 1, Hóc Môn, Hồ Chí Minh',
      description: 'RinRin Park là công viên cá coi có quy mô lớn nhất Việt Nam.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031145237388.jpg',
      rating: 4.0,
      location: LatLng(10.8630, 106.5930),
      category: 'entertainment',
      tags: ['cá koi', 'công viên', 'lớn nhất'],
      openingHours: '7:00 - 19:00',
      price: 55000,
    ),

    Attraction(
      id: '188',
      name: 'Cánh đồng hoa Nhị Bình',
      address: 'Bờ bao sông, Nhị Bình, Hóc Môn, Hồ Chí Minh',
      description: 'Cánh đồng hoa Nhị Bình với những thảm hoa đầy màu sắc và không gian chụp ảnh đẹp.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031145549603.jpg',
      rating: 4.2,
      location: LatLng(10.8640, 106.5940),
      category: 'nature',
      tags: ['cánh đồng hoa', 'chụp ảnh', 'màu sắc'],
      openingHours: '7:30 - 18:30',
      price: 100000,
    ),

    Attraction(
      id: '189',
      name: 'Di Tích Dinh Quận Hóc Môn (Bảo Tàng Huyện Hóc Môn)',
      address: 'số 1 Lý Nam Đế, Ap Dinh, Tân Xuân, Hóc Môn, Hồ Chí Minh',
      description: 'Bảo tàng lưu giữ nhiều hiện vật và tài liệu lịch sử của địa phương.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031146272100.jpg',
      rating: 4.5,
      location: LatLng(10.8650, 106.5950),
      category: 'museum',
      tags: ['bảo tàng', 'di tích', 'lịch sử'],
      openingHours: '7:00 - 19:00',
      price: 0,
    ),

    Attraction(
      id: '190',
      name: 'Chùa Vĩnh Phước',
      address: '28/10A KP.3, Trường Chinh, Tân Thới Nhất, Quận 12, Hồ Chí Minh',
      description: 'Chùa Vĩnh Phước là ngôi chùa có kiến trúc truyền thống và không gian thanh tịnh.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031147000714.jpg',
      rating: 4.4,
      location: LatLng(10.8660, 106.5960),
      category: 'religious',
      tags: ['chùa', 'truyền thống', 'thanh tịnh'],
      openingHours: '4:00 - 14:30',
      price: 0,
    ),

    Attraction(
      id: '191',
      name: 'Chùa Hoằng Pháp',
      address: '96 ấp Tân Thới 3, Tân Hiệp, Hóc Môn, Hồ Chí Minh',
      description: 'Ngôi chùa này là trung tâm văn hóa Phật giáo lớn nhất tại Việt Nam và cũng đang là trung tâm học Phật pháp.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031147578943.jpg',
      rating: 4.7,
      location: LatLng(10.8670, 106.5970),
      category: 'religious',
      tags: ['chùa', 'phật giáo', 'trung tâm'],
      openingHours: '5:00 - 20:30',
      price: 0,
    ),

    Attraction(
      id: '192',
      name: 'Khu Vui Chơi Du Lịch Sinh Thái Sunshine Hóc Môn',
      address: 'Thới Tam Thôn, Hóc Môn, Hồ Chí Minh',
      description: 'Tham quan nông trại với đường dù, cầu săn mây, lâu đài, cầu tình yêu, xe lửa, xe tăng, làng u Cơ, cầu khỉ, giếng nước, xay bột, chèo xuồng, lùa vịt, vườn thú, bắt cá, tắm mưa.',
      imageUrl: 'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031148383600.jpg',
      rating: 4.5,
      location: LatLng(10.8680, 106.5980),
      category: 'entertainment',
      tags: ['sinh thái', 'nông trại', 'trò chơi'],
      openingHours: '7:00 - 21:00',
      price: 200000,
    ),

    Attraction(
      id: '193',
      name: 'Gà bó xôi 1Ngon',
      address: '65/6 Nguyễn Thị Huê, ấp Trung Lân, xã Bà Điểm, Huyện Hóc Môn, Hồ Chí Minh',
      description: 'Quán gà bó xôi nổi tiếng với hương vị đặc trưng và cách chế biến độc đáo.',
      imageUrl: 'assets/images/attractions/ga_bo_xoi_1ngon.jpg',
      rating: 4.2,
      location: LatLng(10.8690, 106.5990),
      category: 'food',
      tags: ['gà bó xôi', 'đặc trưng', 'độc đáo'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '194',
      name: 'Gà hấp hèm 6 Vĩnh',
      address: '1/132B Ấp Đình, Tân Xuân, Huyện Hóc Môn, Hồ Chí Minh',
      description: 'Quán gà hấp hèm với công thức gia truyền và hương vị đậm đà.',
      imageUrl: 'assets/images/attractions/ga_hap_hem_6_vinh.jpg',
      rating: 4.3,
      location: LatLng(10.8700, 106.6000),
      category: 'food',
      tags: ['gà hấp hèm', 'gia truyền', 'đậm đà'],
      openingHours: '16:00 - 22:00',
      price: 0,
    ),

    Attraction(
      id: '195',
      name: 'Bún đậu Làng Vòng',
      address: '47/5D Nguyễn Hữu Cầu, Trung Mỹ Tây, Hóc Môn, Hồ Chí Minh',
      description: 'Quán bún đậu mắm tôm với hương vị truyền thống và không gian dân dã.',
      imageUrl: 'assets/images/attractions/bun_dau_lang_vong.jpg',
      rating: 4.1,
      location: LatLng(10.8710, 106.6010),
      category: 'food',
      tags: ['bún đậu', 'mắm tôm', 'dân dã'],
      openingHours: '10:00 - 21:00',
      price: 0,
    ),

    Attraction(
      id: '196',
      name: 'Bò kho Mẹ Nấu',
      address: '56/1 Phan Văn Hớn, Huyện Hóc Môn, Hồ Chí Minh',
      description: 'Quán bò kho gia đình với hương vị đậm đà và phục vụ tận tình.',
      imageUrl: 'assets/images/attractions/bo_kho_me_nau.jpg',
      rating: 4.4,
      location: LatLng(10.8720, 106.6020),
      category: 'food',
      tags: ['bò kho', 'gia đình', 'tận tình'],
      openingHours: '6:00 - 14:00',
      price: 0,
    ),
  ];
}

/*
Thảo Cầm Viên
Bến Bạch Đằng
Đường sách Nguyễn Văn Bình
Saigon Garden
Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh[
số 97A Phó Đức Chính, Phường Nguyễn Thái Bình,
Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh là điểm đến yêu thích của những người yêu nghệ thuật và văn hóa. Bảo tàng là nơi thu thập, trưng bày, bảo quản các tác phẩm nghệ thuật hiện đại, đương đại của các nghệ sĩ Việt Nam và quốc tế.,
]
Phố Nhật Little Japan Sài Gòn[
đường Thái Văn Lung, Phường Bến Nghé
Phố Nhật Sài Gòn Little Japan là một khu vực tập trung nhiều cửa hàng, quán cà phê, nhà hàng Nhật Bản
]
Saigon Outcast[
188/1 Nguyễn Văn Hưởng, phường Thảo Điền, Quận 2, Thành phố Hồ Chí Minh
Saigon Outcast là tổ hợp vui chơi, giải trí, sáng tạo đậm chất nghệ thuật đường phố.
]
Family Garden[
28 Thảo Điền, phường Thảo Điền, Quận 2, Thành phố Hồ Chí Minh
là một trong những địa điểm đang hot ở Sài Gòn với nhiều khu vui chơi hấp dẫn.
]
Thảo Điền Village[
89 – 197 Nguyễn Văn Hưởng, phường Thảo Điền, Quận 2, Thành phố Hồ Chí Minh
Thảo Điền Village có một không gian thoáng đãng, xanh mát cực kỳ dễ chịu.
]
khu trượt tuyết Snow Town[
Lầu 3 The CBD Premium Home, 125 Đồng Văn Cống, phường Thạnh Mỹ Lợi, Thành phố Thủ Đức,
Snow Town là một khu trượt tuyết nhân tạo trong nhà nổi tiếng của Sài Gòn.
]
Công viên bờ sông Sài Gòn[
Khu đô thị mới Thủ Thiêm, Thành phố Thủ Đức
là một tụ điểm vui chơi mới của thành phố. Tọa lạc tại khu đô thị mới Thủ Thiêm,
]
Bãi thả diều chân cầu Thủ Thiêm[
Khu đô thị mới Thủ Thiêm, Quận 2, Thành phố Hồ Chí Minh,
bãi diều rộng lớn, người bán, người thả diều tấp nập và những con diều nhiều màu sắc trên bầu trời.
]
Nhà thờ Giáo xứ Tân Định[
289 Hai Bà Trưng, Phường 8, Quận 3,
8h -12h và 14h - 17h (đóng cửa thứ Bảy, Chủ Nhật),
Nhà thờ Giáo xứ Tân Định với không gian ngập tràn sắc hồng dịu dàng là một địa điểm check-in quen thuộc đối với các tín đồ thích khám phá
]
Phố ẩm thực Nguyễn Thượng Hiền[
đường Nguyễn Thượng Hiền, phường 4, 5, quận 3,
19h - 23h
Phố ẩm thực Nguyễn Thượng Hiền là một tuyến phố ngắn khá sầm uất với nhiều mặt hàng đồ ăn thức uống nổi tiếng.
]
Hồ bơi Kỳ Đồng[
40 Kỳ Đồng, phường 9, Quận 3
6h - 18h
 Đây là địa điểm vui chơi và sinh hoạt thể thao quen thuộc đối với những bạn trẻ yêu thích bơi lội cùng các gia đình có con nhỏ tại quận 3
]
The Box Market Quận 3[
Trung tâm văn hóa thể thao quận 3 - 136 Cách mạng Tháng Tám,
 10h - 22h
 The Box Market là phiên chợ cuối tuần đặc biệt được diễn ra ở Trung tâm Văn hóa Thể thao Quận 3.
]
Poc Poc Beer Garden[
79A Nguyễn Đình Chiểu, Phường 6, Quận 3,
17h - 2h sáng hôm sau,
Poc Poc Beer Garden là địa điểm giải trí quen thuộc với những tín đồ du lịch thích sự sôi động và náo nhiệt của tiếng nhạc.
]
Chùa Pháp Hoa[
870 đường Trường Sa, phường 14, quận 3,
6h - 11h30 và 13h30 - 21h,
Chùa Pháp Hoa là địa điểm tôn giáo nổi tiếng tại quận 3 với kiến trúc độc đáo với không gian thoáng đãng nằm cạnh một dòng kênh ở trung tâm thành phố.
]
Cầu Mống Quận 4[
33 Bến Vân Đồn, Phường 7, Quận 4, TP. Hồ Chí Minh.
Cây cầu này luôn thu hút đông đảo các bạn trẻ với nhiều hoạt động sôi nổi như chụp hình check-in, ngắm bình minh hay hoàng hôn vô cùng đẹp, hẹn hò lãng mạn hay thưởng thức những món ăn ở các gánh hàng rong.
]
Bến Nhà Rồng[
Bến Nhà Rồng còn mang phong cách hữu tình ngay bờ sông Sài Gòn với không khí thoáng đãng nên rất đông du khách cả trong và ngoài nước đến đây.
1 Nguyễn Tất Thành, Phường 12, Quận 4, TP. Hồ Chí Minh
]
Chợ Xóm Chiếu Quận 4[
à một trong những địa điểm ăn uống, vui chơi sầm uất nhất nhì Sài Gòn, chợ Xóm Chiếu luôn thu hút đông đảo du khách với những món ăn vặt hấp dẫn.
92B/20 Tôn Thất Thuyết, Phường 16, Quận 4, TP. Hồ Chí Minh
]
Công viên Khánh Hội Quận 4[
Được mệnh danh là “lá phổi xanh” của Quận 4 Thành phố Hồ Chí Minh, công viên Khánh Hội có diện tích hơn 4,9ha được phủ xanh bằng rất nhiều loại cây cối khác nhau
đường số 48, Phường 5, Quận 4, TP. Hồ Chí Minh
]
Phố người Hoa Quận 5[
Trần Hưng Đạo - Phường 6 - Quận 5 - Tp. Hồ Chí Minh
khu phố có nhiều người Hoa sinh sống nhất tại Sài Gòn để trải nghiệm nền văn hóa Trung Hoa, tinh túy ẩm thực nổi tiếng
]
Phố đèn lồng Lương Nhữ Học Quận 5[
Lương Nhữ Học - Phường 11 - Quận 5 - Tp. Hồ Chí Minh,
Phố đèn lồng Lương Nhữ Học Quận 5 là một trong những điểm vui chơi Sài Gòn về đêm nổi tiếng nhất Sài thành. Bởi nơi đây có những dãy phố bán hàng ngàn chiếc đèn lồng với nhiều màu sắc khác nhau.
]
chợ Thủ Đô Quận 5[
220 Phùng Hưng - Phường 14 - Quận 5 - Tp. Hồ Chí Minh
Chợ Thủ Đô là một trong những địa điểm vui chơi ở Quận 5 được rất nhiều người ghé thăm để thưởng thức các loại đặc sản, tinh túy ẩm thực Sài Gòn
]
The Garden Mall[
190 Hồng Bàng - Phường 12 - Quận 5 - Tp. Hồ Chí Minh,
]
Chợ An Đông[
34 - 36 An Dương Vương - Phường 9 - Quận 5 - Tp. Hồ Chí Minh,
An Đông là một ngôi chợ có tuổi đời khá lâu tại Sài Gòn, đây là cụm chợ đầu mối được đánh giá là lớn nhất tại Việt Nam hiện nay.
]
Chùa cổ Tuyền Lâm [
887 Hồng Bàng, phường 9, quận 6, TP. Hồ Chí Minh,
]
Chợ đầu mối Bình Điền[
Quản Trọng Linh, Phường 7, Bình Chánh, Thành phố Hồ Chí Minh
20h00 - 6h00
]
Công viên Grand Park[
Vinhomes Grand Park, đường Nguyễn Xiển, Phước Thiện, P. Long Thạch Mỹ, Quận 9 cũ (nay là TP Thủ Đức), TP. Hồ Chí Minh
Công Viên Grand Park là khu vui chơi mới ở Quận 9 đáng mong chờ khi sẽ mang đến hàng loạt trải nghiệm đỉnh cao. Với tổ hợp công viên nước hiện đại,
Đầm sen Tam Đa
361/20 đường Tam Đa, P. Trường Thạnh, TP. Thủ Đức
05:00 - 17:
 50.000 VNĐ/người
  Đầm sen Tam Đa là gợi ý lý tưởng cho hoạt động dã ngoại, chụp ảnh và câu cá
]
Chùa Bửu Long[
81 Nguyễn Xiển, P. Long Bình, TP. Thủ Đức,
Chùa Bửu Long nằm trong top 10 công trình Phật giáo đẹp nhất thế giới do tạp chí National Geographic bình chọn.
]
Đền tưởng niệm Vua Hùng[
Công viên Lịch sử Văn hóa Dân Tộc, P. Long Bình, TP. Thủ Đức
Đền tưởng niệm Vua Hùng nằm trên ngọn đồi cao hơn 20m trong Công viên Lịch sử Văn hóa Dân tộc là đền thờ vua Hùng lớn nhất miền Nam.
]
Chùa Châu Đốc 3 (chùa Phước Long)[
Cù lao Bà Sang, P. Long Bình, TP. Thủ Đức
Chùa Châu Đốc 3 hay còn gọi chùa Phước Long là công trình tâm linh nổi tiếng nằm trên cù lao giữa sông Đồng Nai.
]




Phố đi bộ quận 10[
Vòng xoay Kỳ Đài Quang Trung, Phường 6, Quận 10, Thành phố Hồ Chí Minh,
]
Chợ hoa Hồ Thị Kỷ[
Hẻm 52 Đường Hồ Thị Kỷ, Phường 1, Quận 10, Thành phố Hồ Chí Minh,
Chợ hoa Hồ Thị Kỷ là một trong những khu chợ chuyên bán hoa có quy mô lớn nhất ở Sài Gòn
]
Chợ đồ cũ Nhật Tảo[
Đường Nhật Tảo, Phường 7, Quận 10, Thành phố Hồ Chí Minh,
Nhật Tảo là khu chợ chuyên bán đồ secondhand, rất thích hợp với những bạn thích sưu tầm đồ công nghệ, đồ điện tử giá tốt.
]
Khu trưng bày tượng sáp Việt[
240 Đường 3 Tháng 2, Phường 14, Quận 10, Thành phố Hồ Chí Minh,
Tại đây trưng bày tượng sáp các nghệ sĩ Việt Nam như nhạc sĩ, diễn viên, nghệ sĩ nhân dân… từ cuối thế kỷ XX đến nay.
]
karaoke Sư Vạn Hạnh[
Đường Sư Vạn Hạnh, Quận 10, Thành phố Hồ Chí Minh
Sư Vạn Hạnh là con đường cực kỳ sầm uất và nổi tiếng là thiên đường ăn chơi của quận 10
]
Bảo tàng y học Việt Nam[
41 Đường Hoàng Dư Khương, Phường 12, Quận 10, Thành phố Hồ Chí Minh
Bảo tàng y học Việt Nam sẽ mở ra cho bạn một không gian rất bình yên, tĩnh lặng, chìm trong những mùi hương thoang thoảng của vô số loại thảo mộc.
]
Việt Nam Quốc Tự[
244 Đường 3 Tháng 2, Phường 12, Quận 10, Thành phố Hồ Chí Minh
Ngôi chùa này được xây dựng với phong cách kiến trúc truyền thống, quy mô rất lớn, đặc biệt phải kể đến tòa tháp 13 tầng
]
Nhà hát Hòa Bình[
240 Đường 3 Tháng 2, Phường 12, Quận 10, Thành phố Hồ Chí Minh,
Đây là địa điểm thường xuyên tổ chức các buổi biểu diễn chuyên nghiệp, liveshow của những ca sĩ tên tuổi cả trong nước và quốc tế
]
Hội An Quán[
285/94A Hẻm 285 Cách Mạng Tháng Tám, Phường 12, Quận 10, Thành phố Hồ Chí Minh,
img:'https://mia.vn/media/uploads/blog-du-lich/quan-10-co-gi-choi-hoi-an-quan-1712072502.jpg'
]
Bún đậu mắm tôm Tiến Hải[
409 Đ. Nguyễn Tri Phương, Phường 5, Quận 10, Thành phố Hồ Chí Minh
]
Bánh Canh Cua Gia Truyền Cô Dung[
22 hẻm/269 Đ. Vĩnh Viễn, Phường 5, Quận 10, Thành phố Hồ Chí Minh
]
Bánh tráng cuốn trộn Biển Vương[
Chung Cư Ngô Gia Tự, 013 Lô R, Phường 2, Quận 10, Thành phố Hồ Chí Minh
]
Chè Sinh Viên[
Lô R, Phường 2, Quận 10, Thành phố Hồ Chí Minh
]
Công viên Văn hóa Đầm Sen[
Công viên Văn hóa Đầm Sen là một trong những địa điểm vui chơi vô cùng nổi tiếng ở thành phố Hồ Chí Minh. ,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114613/cong-vien-van-hoa-dam-sen-quan-11-co-gi-vui-768x512.jpg',
1A Lạc Long Quân, Phường 5, Quận 11, Thành phố Hồ Chí Minh
]
Công viên nước Đầm Sen[
Với 36 trò chơi đa dạng, hấp dẫn, công viên nước Đầm Sen là địa điểm vui chơi lý tưởng cho những nhóm bạn thích trải nghiệm.,
3 Hòa Bình, Phường 3, Quận 11, Thành phố Hồ Chí Minh
]
Nhà thi đấu Phú Thọ[
Nhà thi đấu Phú Thọ là một trong những nhà thi đấu đa năng lớn của thành phố Hồ Chí Minh với sức chứa tối đa lên đến 8.000 người.,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114622/nha-thi-dau-phu-tho-quan-11-co-gi-vui-768x512.jpg',
1 Lữ Gia, Phường 15, Quận 11, Thành phố Hồ Chí Minh
]
Hồ bơi Phú Thọ[
Nằm tại khu vực dân cư đông đúc nên hồ bơi Phú Thọ đã trở thành địa điểm thu hút của nhiều cư dân đến học bơi và tham gia bơi lội,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114615/ho-boi-phu-tho-quan-11-co-gi-vui-768x512.jpg',
215A Lý Thường Kiệt, Phường 15, Quận 11, Thành phố Hồ Chí Minh
]
Khánh Vân Nam Viện Đạo quán[
Khánh Vân Nam Viện Đạo quán được xây dựng theo lối kiến trúc Trung Quốc và là ngôi đạo quán lớn nhất miền Nam.,
269/2 Nguyễn Thị Nhỏ, Phường 16, Quận 11, Thành phố Hồ Chí Minh,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114620/khanh-van-nam-vien-quan-11-co-gi-vui-768x512.jpg'
]
Baoz Dimsum[
Baoz Dimsum là một trong những thương hiệu cực kỳ nổi tiếng với các món ăn truyền thống của Trung Quốc. Menu với hơn 100 món chắc chắn sẽ chinh phục được khẩu vị của mọi thực khách.,
297 – 299 Lê Đại Hành, Phường 13, Quận 11, Thành phố Hồ Chí Minh,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114609/baoz-dimsum-quan-11-co-gi-vui-768x512.jpg'
]
Katinat Saigon Kafe[
Katinat Saigon Kafe đã trở thành địa điểm hẹn hò yêu thích của giới trẻ Sài Thành.,
img:'https://go2joy.s3.ap-southeast-1.amazonaws.com/blog/wp-content/uploads/2022/11/22114617/katinat-quan-11-co-gi-vui-768x512.jpg',
8 Lê Đại Hành, Phường 11, Quận 11, Thành phố Hồ Chí Minh
]
Khu du lịch Bến Xưa quận 12[
39A Hà Huy Giáp, Thạnh Lộc, Quận 12, TP.Hồ Chí Minh
rating: 4.3,
Khoảng 328.000 đồng/ vé,
 07h00-21h00 ,
Với vị trí đẹp, nằm kế con sông Vàm Thuật, bao quanh là tán cây xanh mướt, không gian nơi đây là điểm thư giãn lý tưởng với những ai tìm kiếm sự yên tĩnh sau những ngày vội vã giữa thành phố xô bồ.,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011327232464.jpg'
]
Tu viện Khánh An[
3D Quốc lộ 1A, phường An Phú Đông, Quận 12, TP.Hồ Chí Minh,
rating:4.6,
free,
05h00-21h00,
được thiết kế theo kiến trúc chùa Nhật Bản vô cùng độc đáo và thú vị, thu hút nhiều khách du lịch ghé thăm.
img;'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011328143306.jpg'
]
Làng cá sấu[
rating: 4.3,
Đường Nguyễn Thị Sáu, Thạnh Lộc, Quận 12, TP. Hồ Chí Minh,
free,
08h00 - 20h00,
không gian xanh mướt vườn cây đậm chất làng quê Miền Tây, cùng những trang trại nuôi nhốt cá sấu vô cùng thú vị,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011328552278.jpg'
]
Khu tưởng niệm Vườn Cau Đỏ[
rating:4.2,
12 Thạnh Xuân 52, Thạnh Xuân, Quận 12, TP.Hồ Chí Minh,
free
24/7,
Khu tưởng niệm Vườn Cau Đỏ được coi là điểm đến tham quan mang đậm giá trị lịch sử kháng chiến giành lại độc lập của dân tộc Việt Nam.,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011329272234.jpg'
]
Moda House Coffee[
Moda House Coffee,
Khoảng 12.000 đồng-50.000 đồng,
07h00-23h30,
Moda House Coffee là một điểm đến vô cùng lí tưởng với các tín đồ sống ảo và selfie. ,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011329573450.jpg'
]
Ấm Coffee[
Vườn Lài, An Phú Đông, Quận 12, TP.Hồ Chí Minh,
rating: 4.8,
Khoảng 25.000 đồng-45.000 đồng,
07h00-22h00,
Ấm coffee là quán nước được thiết kế theo phong cách vintage đẹp mắt, xung quanh là những dãy đèn, vào buổi tối những ánh đèn lung linh sáng khắp không gian quán tạo một cảm giác vô cùng ấm cúng vào lãng mạng.,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011330404759.jpg'
]
Nông trại Tam Nông[
rating: 4.0,
Tổ 33 kp2, Thạnh Xuân, Quận 12, TP.Hồ Chí Minh,
free,
08h00-21h00,
Nông trại Tam Nông là địa điểm du lịch làm theo mô hình trang trại nông thuỷ sản,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011331267779.jpg'
]
Quán mì Quảng 48 quan 12
Bún chả Đàm Trang[
27 Tân Chánh Hiệp 10, quận 12 ,
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011332126027.jpg'
]
Thỏ Sushi quan 12[
img:'https://cdn.tgdd.vn/Files/2023/02/28/1513453/tong-hop-10-dia-diem-vui-choi-quan-12-giai-tri-cuoi-ngay-202303011332255077.jpg',
]
Công viên Vinhomes Central Park[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030818526525.jpg',
208 Nguyễn Hữu Cảnh, phường 22, quận Bình Thạnh, thành phố Hồ Chí Minh,
rating: 4.5,
free,
8h00 - 22h00 ,
Khu công viên mang nét đẹp hiện đại, không gian rộng thoáng, nhiều góc sống ảo, nhiều cây xanh, có bãi cỏ rộng để vui chơi.
]
Ươm Art Hub[
rating:4.3,
42/58 Hoàng Hoa Thám, phường 7, quận Bình Thạnh, thành phố Hồ Chí Minh,
free,
8h00 - 22h00,
Ươm Art Hub là một khu phức hợp với nhiều khu vực khác nhau như: Studio De Egg, Tiệm sách The Razcals, Design Anthropology School (DAS), Tiệm xăm Tattoonista, quán F&B
]
Khu du lịch Văn Thánh[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030819571622.jpg',
rating:4.2,
48/10 Điện Biên Phủ, phường 22, quận Bình Thạnh, thành phố Hồ Chí Minh,
Khoảng 60.000 đồng cho người lớn và 30.000 đồng cho trẻ em,
10h00 - 20h00,
Khu du lịch Văn Thánh nằm trong khuôn viên của bán đảo Thanh Đa, là nơi lý tưởng để bạn thư giãn cuối tuần, có đủ hồ bơi, sân tennis, view cafe đẹp tuyệt.
]
Khu du lịch Tân Cảng[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030820276672.jpg',
rating: 4.1,
A100 Ung Văn Khiêm, phường 25, quận Bình Thạnh, thành phố Hồ Chí Minh,
Khoảng 390.000 đồng cho người lớn, 200.000 đồng cho trẻ em,
 8h00 - 21h30 ,
 Quán có view sông thoáng mát, đồ ăn khá ổn, phục vụ nhanh. Vừa ăn vừa có thể ngắm tàu chạy, cảm giác thư giãn thoải mái.
]
Khu du lịch Bình Quới 2[
rating:4.0,
556 Bình Quới, phường 28, quận Bình Thạnh, thành phố Hồ Chí Minh,
free,
10h00 - 22h00,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030821085287.jpg'
]
Khu du lịch Bình Quới 1[
rating: 3.7,
1147 Bình Quới, Phường 28, Bình Thạnh, thành phố Hồ Chí Minh,
Khoảng 130.000 đồng cho người lớn và 90.000 đồng cho trẻ em,
08h00 - 18h00 từ thứ hai đến thứ sáu, 8h00 - 21h00 thứ 7, chủ nhật,
Khu du lịch Bình Quới 1 có không gian xanh và có những cảnh đẹp để sống ảo. Đội ngũ phục vụ tại khu vực ẩm thực đặt trước đều tận tình và chu đáo,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030821440327.jpg'
]
Lăng Ông Bà Chiểu[
01 Vũ Tùng, phường 1, quận Bình Thạnh, thành phố Hồ Chí Minh,
free,
7h00 - 17h00,
Lăng Ông Bà Chiểu là lăng thờ Tả Quân Lê Văn Duyệt và thường gọi là Lăng Ông.,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030822293369.jpg'
]
Chợ Bà Chiểu[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030822568896.jpg',
Đường Bạch Đằng, phường 1, quận Bình Thạnh, thành phố Hồ Chí Minh,
free,
 5h00 - 22h00,
 Chợ Bà Chiểu là khu chợ lâu đời và quen thuộc đối với người dân Sài Gòn. Chợ Bà Chiểu gồm 8 khu chính với hơn 40 ngành hàng khác nhau thuộc 800 hộ kinh doanh
]
JeJu Coffee[
448 đường Phạm Văn Đồng, phường 13, quận Bình Thạnh, thành phố Hồ Chí Minh,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030823537578.jpg',
JeJu Coffee nổi bật bởi góc sống ảo ở bên ngoài, style Hàn Quốc nên nhìn xinh lắm, bước vô là nguyên 1 khu vườn đầy cây xanh mát, nhiều góc sống ảo nhìn rất đẹp.
]
Nhà hàng Phong Cua 2[
1067 Bình Quới, phường 28, quận Bình Thạnh, thành phố Hồ Chí Minh,
img:''https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030824091755.jpg,
Nhà hàng Phong Cua 2 được đánh giá cao bởi chất lượng hải sản tươi ngon, đặc biệt là món cua được nhiều thực khách yêu thích.
]
Quán Le Steak[
Hẻm 26 đường D5, phường 25, quận Bình Thạnh, thành phố Hồ Chí Minh,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514450/nhung-dia-diem-vui-choi-quan-binh-thanh-nhat-dinh-phai-den-202303030824371414.jpg',
Quán Le Steak có không gian nhỏ nên các bạn đặt bàn trước để không phải đợi lâu nhé. Chất lượng đồ ăn ổn, giá không quá đắt.
]
Chợ Hạnh Thông Tây[
10/2 Quang Trung, Phường 11, quận Gò Vấp,
img:'https://statics.vinpearl.com/quan-go-vap-co-gi-choi-8_1631529140.jpg'
]
Country House Coffee[
18C Phan Văn Trị, Phường 10, quận Gò Vấp,
img:'https://statics.vinpearl.com/quan-go-vap-co-gi-choi-9_1631529180.jpg',
25.000 - 50.000
Quán được ví như Đà Lạt thu nhỏ giữa lòng thành phố
]
Khu ẩm thực Phan Xích Long[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030753180957.jpg',
Phan Xích Long, phường 2, quận Phú Nhuận, thành phố Hồ Chí Minh,
]
Nhà thi đấu Quân khu 7[
rating: 4.6,
202 Hoàng Văn Thụ, Phường 9, Phú Nhuận, Thành phố Hồ Chí Minh,
Nhà thi đấu Quân khu 7 với sức chứa hơn 20.000 người, là nơi tổ chức của nhiều sự kiện lớn - nhỏ trong nước.,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030753516841.jpg'
]
Hồ bơi Rạch Miễu[
1 Hoa Phượng, Phường 2, Phú Nhuận, Thành phố Hồ Chí Minh,
rating:4.1,
Khoảng 25.000 đồng/vé,
13h30 - 15h15, 15h30 - 17h15, 17h30 - 19h00 ,
Hồ bơi Rạch Miễu là một trong những địa điểm bơi lội cực chất ở thành phố Hồ Chí MInh.
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030754233325.jpg'
]
Cơm tấm Ba Ghiền[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755199443.jpg',
84 Đặng Văn Ngữ, phường 10, quận Phú Nhuận, TP.HCM,
Cơm tấm Ba Ghiền với nhiều món ăn kèm vô cùng thơm ngon, mới lạ. ,
]
Bún riêu hẻm Ông Tiên[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755332363.jpg',
Hẻm 96 Phan Đình Phùng, Phường 2, Phú Nhuận, Thành phố Hồ Chí Minh,
]
Phở Hoa Bắc[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030755472457.jpg',
50F2 Đường Hoa Cau, Phường 7, Phú Nhuận, Thành phố Hồ Chí Minh,
]
Ốc luộc Huỳnh Văn Bánh[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514443/tong-hop-4-dia-diem-vui-choi-quan-phu-nhan-cuc-hap-dan-cho-ban-tre-202303030756035333.jpg',
533/59 Huỳnh Văn Bánh, Phường 14, Phú Nhuận, Thành phố Hồ Chí Minh
]
Công viên Hoàng Văn Thụ[
Hoàng Văn Thụ, Phường 2, Tân Bình, Thành phố Hồ Chí Minh,
rating: 4.4,
free,
07h00 - 22h00,
Được mệnh danh là lá phổi xanh của thành phố, công viên Hoàng Văn Thụ là địa điểm đi chơi ở quận Tân Bình được nhiều người yêu thích với diện tích 106.500m2. ,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040014024466.jpg',
]
Chùa Viên Giác[
rating: 4.7,
193 Bùi Thị Xuân, Phường 1, Tân Bình, Thành phố Hồ Chí Minh,
free
06h00 - 21h00 ,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040014356517.jpg',
Chùa Viên Giác hiện tọa lạc tại tại số 193 Bùi Thị Xuân - Quận Tân Bình mang lại cảm giác an lạc thanh tịnh trong kiến trúc Phật giáo cổ kính uy nghiêm.
]
Chùa Phổ Quang[
rating: 4.6,
21 Huỳnh Lan Khanh, Phường 2, Tân Bình, Thành phố Hồ Chí Minh,
free,
06h00 - 21h00,
Chùa Phổ Quang tọa lạc tại 64 Huỳnh Lan Khanh, Phường 2, quận Tân Bình. Đây là ngôi chùa nổi tiếng với bề dày lịch sử được nhiều người dân Sài Gòn lui đến.
]
CGV Trường Sơn (CGV CT Plaza)[
rating:4.2,
60A Trường Sơn, Phường 2, Tân Bình, Thành phố Hồ Chí Minh,
Khoảng 75.000 - 165.000 đồng/vé,
09h00 - 21h00,
CGV Trường Sơn (CGV CT Plaza) là một trong những cụm rạp chiếu phim được nhiều người ưa chuộng nhất tại Việt Nam,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040017147849.jpg'
]
Tiệm cà phê Hiên Cúc Trắng[
rating: 4.3,
25 Tân Canh, Phường 1, Tân Bình, Thành phố Hồ Chí Minh,
Khoảng 30.000 - 50.000 đồng,
08h00 - 22h00,
Hiên Cúc Trắng là một trong những quán cà phê mang đậm sắc tố hoài cổ, mông mơ và yên bình. ,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040017529003.jpg'
]
Chùa Giác Lâm[
rating: 4.6,
565 Lạc Long Quân, Phường 10, Tân Bình, Thành phố Hồ Chí Minh,
free,
 05h00 - 20h00,
 Chùa Giác Lâm (tổ đình Giác Lâm) là một trong những ngôi chùa có lịch sử lâu đời với hơn 300 năm tuổi.,
 img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040018317511.jpg'
]
Công viên Tân Phước[
rating: 4.1,
9A1 Nguyễn Thị Nhỏ, Phường 9, Tân Bình, Thành phố Hồ Chí Minh,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040019055083.jpg',
free,
 00h00 - 24h00 ,
 Công viên Tân Phước là một trong những công viên lâu đời tại quận Tân Bình.
]
Bảo Tàng Không Quân Phía Nam[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040019392677.jpg',
rating: 4.1,
87 Thăng Long, Phường 4, Tân Bình, Thành phố Hồ Chí Minh,
free,
07h30 - 15h30 ,
Nơi đây lưu giữ nhiều hiện vật, tài liệu về cuộc kháng chiến chống thực dân và đế quốc xâm lược.
]
Vincom Plaza Cộng Hoà[
rating: 4.0,
17 Đ. Cộng Hòa, Phường 4, Tân Bình, Thành phố Hồ Chí Minh,
08h00 - 22h00,
free,
Vincom Plaza Cộng Hòa được thiết lập với những chuẩn mực mới về sự tiện lợi,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040020172163.jpg'
]
Bảo tàng Lực lượng Vũ trang Miền Đông Nam Bộ[
rating: 4.1,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514453/10-dia-diem-vui-choi-quan-tan-binh-duoc-yeu-thich-nhat-dinh-phai-ghe-202303040020595161.jpg',
free,
247 Hoàng Văn Thụ, Phường 1, Tân Bình, Thành phố Hồ Chí Minh,
07h00 - 16h30,
Bảo tàng Lực lượng Vũ trang Miền Đông Nam Bộ có nhiều hiện vật lịch sử các thời kỳ kháng chiến chống Pháp - Mỹ.
],
Kimbap Hoàng tử[
337/2 Đ. Lê Văn Sỹ, Phường 1, Tân Bình, Thành phố Hồ Chí Minh,
]
Moon Fast Food: [
53 Xuân Hồng, phường 4, quận Tân Bình, TPHCM.
]
Mì gà quay San San[
1235 Hoàng Sa, Phường 5, Tân Bình, TPHCM,
]
Cháo sườn Ông Tạ[
402 Phạm Văn Hai, phường 5, quận Tân Bình, TPHCM,
]
Heart Kitchen:[
234 Đồng Đen, Phường 14, Tân Bình, Thành phố Hồ Chí Minh, Việt Nam.
]
Aeon Mall Tân Phú[
30 Bờ Bao Tân Thắng, Sơn Kỳ, Tân Phú, Thành phố Hồ Chí Minh.,
20.000 VNĐ – 1.000.000 VNĐ,
9h00 – 22h00,
]
Galaxy Trường Chinh[
Co.opMart TTTM Thắng Lợi, 2 Đ. Trường Chinh, P, Tân Phú, Hồ Chí Minh.,
60.000 VNĐ – 120.000 VNĐ/vé.,
8:00 – 23:00.,
img:'https://cdn.xanhsm.com/2024/12/2b592dbf-tan-phu-co-gi-choi-3.jpg'
]
Starbucks Pandora City[
Số 1, Đ. Trường Chinh, Phường 15, Tân Phú, Hồ Chí Minh.,
50.000 VNĐ – 150.000 VNĐ.,
 7:00 – 22:00.,
 img:'https://cdn.xanhsm.com/2024/12/39e9e5da-tan-phu-co-gi-choi-5.jpg'
]
Công viên Celadon City[
số 88, Đ. N1, phường Sơn Kỳ, quận Tân Phú TP.HCM.,
free,
5:00 – 21:00.,
Công viên Celadon City là một trong những mảng xanh hiếm hoi tại Tân Phú, nơi lý tưởng để thư giãn hoặc tham gia các hoạt động ngoài trời.,
img:'https://cdn.xanhsm.com/2024/12/8feeefef-tan-phu-co-gi-choi-6.jpg'
]
Chùa Pháp Vân[
số 16 Đ. Lê Thúc Hoạch, Phú Thọ Hoà, Tân Phú, Hồ Chí Minh.,
free,
6:00 – 21:00.,
Tọa lạc tại quận Tân Phú, Chùa Pháp Vân là điểm đến bình yên dành cho những ai muốn tìm kiếm sự tĩnh lặng giữa nhịp sống đô thị.
img:'https://cdn.xanhsm.com/2024/12/f70e8f23-tan-phu-co-gi-choi-7.jpg'
]
Khu vui chơi Top World Tân Phú[
số 685 Đ. Âu Cơ, Tân Thành, Tân Phú, Hồ Chí Minh.,
50.000 VNĐ – 200.000 VNĐ.
0:00 – 21:30.,
img:'https://cdn.xanhsm.com/2024/12/00ecff67-tan-phu-co-gi-choi-8.jpg'
]
Bánh Ép Huế Thi Thi[
 Số 49 Đ. Tân Thắng, P. Sơn Kỳ, Q. Tân Phú, HCM.,
 10.000 VNĐ – 25.000 VNĐ.,
 15h00 -22h00.,
 Bánh Ép Huế Thi Thi là địa điểm ăn vặt quen thuộc của giới trẻ tại Tân Phú,
 img:'https://cdn.xanhsm.com/2024/12/31f27ad9-tan-phu-co-gi-choi-9.jpg'
]
Chiang Rai Tân Phú[
710/5 Đ. Lũy Bán Bích, Tân Thành, Tân Phú, Hồ Chí Minh.,
 50.000 VNĐ – 150.000 VNĐ.,
  10:30 – 22:00.,
  img:'https://cdn.xanhsm.com/2024/12/0c3bd80b-tan-phu-co-gi-choi-10.jpg',
  Đây là điểm đến lý tưởng cho những tín đồ ẩm thực Thái Lan
]
Soul-in Rooftop Tân Phú[
 số 149 Đ. Độc Lập, Tân Quý, Tân Phú, Hồ Chí Minh.,
  100.000 VNĐ – 320.000 VNĐ.,
   17:00 – 23:00.,
img:'https://cdn.xanhsm.com/2024/12/d6043604-tan-phu-co-gi-choi-11.jpg'
]
Bake rooftop[
281 Tây Thạnh, Tân Phú, Hồ Chí Minh.,
100.000 VNĐ – 200.000 VNĐ.,
17:00 – 00:30.
img:'https://cdn.xanhsm.com/2024/12/1135babd-tan-phu-co-gi-choi-12.jpg'
]
Công viên Gia Phú[
rating:4.2,
Đường CN1, Sơn Kỳ, Bình Tân, Thành phố Hồ Chí Minh,
Khoảng 10.000 - 500.000 đồng,
24/7,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041513168861.jpg',
Công viên Gia Phú là địa điểm lý tưởng cho bạn khi muốn tìm kiếm nơi có không gian trong lành
]
Chùa Huệ Nghiêm[
rating:4.7,
KP2 Đỗ Năng Tế, An Lạc A, Bình Tân, Thành phố Hồ Chí Minh,
free
24/7,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041513572434.jpg'
ngôi chùa được mệnh danh là chốn “bồng lai tiên cảnh” giữa lòng đô thị.
]
Hồ câu Út Phương[
rating:3.8,
78b kênh số 1, Tân Tạo A, Bình Tân, Thành phố Hồ Chí Minh,
Khoảng 50.000 - 300.000 đồng,
24/7,
Hồ câu Út Phương là địa điểm giải trí vô cùng thích hợp dành cho những cánh mày râu muốn trải nghiệm cảm giác câu cá đồng quê chân thực.,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041514387127.jpg'
]
King Koi Coffee[
rating:4.1,
118 đường số 7, Bình Trị Đông B, Bình Tân, Thành phố Hồ Chí Minh,
 Khoảng 50.000 - 200.000 đồng,
 08h00 - 22h00,
 Một trong những địa điểm vui chơi và thư giãn sở hữu không gian vô cùng đẹp mắt với các hồ cá koi sinh động,
 img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041515508372.jpg'
]
Chùa Từ Hạnh[
rating:4.6,
574 Kinh Dương Vương, An Lạc, Bình Tân, Thành phố Hồ Chí Minh,
free
24/7
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041516367716.jpg'
]
Big C An Lạc[
rating:4.5,
:1231 QL1A, khu Phố 5, Bình Tân, Thành phố Hồ Chí Minh,
Khoảng 50.000 - 1.000.000 đồng,
 08h00 - 22h00,
 Big C An Lạc là trung tâm thương mại, vui chơi giải trí lớn nhất nhì quận Bình Tânm
 img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041517448982.jpg'
]
Chợ An Lạc[
rating:4.0,
357 Kinh Dương Vương, An Lạc, Bình Tân, Thành phố Hồ Chí Minh,
Khoảng 50.000 - 1.000.000 đồng,
Là ngôi chợ lâu đời và tấp nập hàng đầu ở quận Bình Tân,,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041518150732.jpg'
]
Quán Ăn Long Ký[
124 đường Số 1, Bình Trị Đông B, Bình Tân, Thành phố Hồ Chí Minh,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041518498251.jpg',
]
Cơm Niêu Thiên Lý[
120 đường số 7, Bình Trị Đông B, Bình Tân, Thành phố Hồ Chí Minh,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519047989.jpg'
]
Lẩu Bò Tư Công Viên[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519236554.jpg',
204 Tên Lửa, Bình Trị Đông B, Bình Tân, Thành phố Hồ Chí Minh,
]
Ăn vặt Nhím Nhím[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514646/dia-diem-vui-choi-quan-binh-tan-10-dia-diem-nhat-dinh-phai-checkin-202303041519462312.jpg',
52 đường số 19, Bình Trị Đông B, Bình Tân, Thành phố Hồ Chí Minh
]
Khu du lịch văn hóa Suối Tiên [
120 Xa Lộ Hà Nội, TP Thủ Đức ,
Combo 30 trò chơi cho trẻ em: 490.000 VNĐ
Combo 30 trò chơi người lớn: 790.000 VNĐ,
Các khu vực trong công viên có kiến trúc và thiết kế được lấy cảm hứng từ những câu chuyện nổi tiếng như Sơn Tinh - Thủy Tinh, Vua Hùng, Âu Cơ - Lạc Long Quân.,
img:'https://statics.vinpearl.com/Khu-du-lich-van-hoa-suoi-tien_1729842968.jpg'
]
Khu du lịch sinh thái Song Long[
số 10 đường D1, Long Phước, TP Thủ Đức ,
8h - 17h (Thứ 7, Chủ Nhật),
90.000 VNĐ/vé/người | Trẻ em (<1,2m): Miễn phí),
Khu du lịch Song Long có không gian sông nước dân dã, gần gũi phù hợp có những ai muốn trải nghiệm không gian trong lành, tránh xa sự ồn ào và hối hả của phố thị. ,
img:'https://statics.vinpearl.com/khu-du-lich-sinh-thai-song-long_1729842996.jpg'
]
Khu du lịch sinh thái Long Phước[
327 đường số 5, khu phố Lân Ngoài, TP Thủ Đức ,
Khu du lịch sinh thái Long Phước Quận 9 nằm cạnh bờ sông, mang đến cho du khách một không gian miệt vườn xanh mát.,
img:'https://statics.vinpearl.com/Khu-du-lich-sinh-thai-Long-Phuoc_1729843076.jpg'
]
Vincom Mega Mall Grand Park[
đường Nguyễn Xiển, Long Bình, Tp Thủ Đức,
Vincom Mega Mall Grand Park có diện tích rộng lớn với hơn 50.000m², quy tụ hơn 140 thương hiệu nổi tiếng trong nước và quốc tế.,
img:'https://statics.vinpearl.com/Vincom-Mega-Mall-Grand-Park_1729843175.jpg'
]
Công viên hầm Thủ Thiêm[
img:'https://statics.vinpearl.com/ham-thu-thiem-sai-gon_1729843239.jpg'
]
Phố Nhật Bản Oishi Town[
28 Thảo Điền, TP Thủ Đức ,
9h - 21h .
Nơi đây giống như một “Nhật Bản thu nhỏ” với không gian được bố trí đậm chất xứ phù tang.
img:'https://statics.vinpearl.com/pho-nhat-oishi-town_1729843310.jpg'
]
Chùa Một Cột Thủ Đức[
100 Đặng Văn Bi, Bình Thọ, TP Thủ Đức ,
Công trình kiến trúc Phật giáo độc đáo này được xây dựng mô phỏng theo kiến trúc Diên Hựu Tự ở thế kỷ XI,
img:'https://statics.vinpearl.com/chua-mot-cot-thu-duc_1729843331.jpg'
]
Lâu đài Long Island[
173 Long Thuận, Long Phước, TP Thủ Đức ,
Lâu đài Long Island được xây dựng trên diện tích rộng 5h, mô phỏng theo kiến trúc cổ kính châu Âu.
img:'https://statics.vinpearl.com/lau-dai-long-island-quan-9_1729843350.jpg'
]
Vietgangz Glamping Club [
169 đường số 5, Long Phước, TP Thủ Đức ,
Nơi đây thích hợp để du khách tìm đến picnic, thư giãn. ,
img:'https://statics.vinpearl.com/khu-cam-trai-vietgangz-glamping-club-saigon_1729843391.jpg'
]
Asia Island Glamping[
195 đường số 5, Long Phước, TP Thủ Đức ,
Asia Island Glamping là khu cắm trại nằm bên sông Sài Gòn, có hệ thống lều trại đầy đủ tiện nghi mang đến cho du khách cảm giác thoải nhưng vẫn gần gần gũi với thiên nhiên,
img:'https://statics.vinpearl.com/nuong-bbq-tai-asia-islan-glamping_1729843412.jpg'
]
Rio Glamping[
35 đường số 5, Long Phước, TP Thủ Đức ,
img:'https://statics.vinpearl.com/Rio-Glamping_1729843433.jpg',
tham gia các trò chơi: chèo thuyền kayak, bóng rổ, bắn cung, câu cá, đốt lửa trại, tổ chức nướng BBQ, check in không gian đẹp…
]
Cafe Thủy Trúc 1982[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030837358919.jpg',
rating: 4.1,
Đường Số 2, Khu Dân Cư Phú Xuân, Nhà Bè, TP.Hồ Chí Minh,
Khoảng 20.000 - 55.000 đồng,
06h15 - 21h00,
Cafe Thủy Trúc 1982 là dạng quán cafe sân vườn rất được nhiều khách hàng ghé thăm, quán có không gian rộng rãi, thức uống đa dạng và nhân viên phục vụ tận tình, giá cả lại rẻ
]
Bến Xưa Cafe - The Old Dock Coffee & Tea[
rating:4.6,
Đường 12, Vạn Hưng Phú, Khu Dân Cư Phú Xuân, Nhà Bè, TP.Hồ Chí Minh,
06h00 - 21h00,
Bến Xưa Cafe - The Old Dock Coffee & Tea là quán cafe sân vườn theo phong cách cổ điển, làng quê rất đặc biệt
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030840086667.jpg'
]
Bún bò Huế O Diện[
img:' https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030841182370.jpg'
]
Cơm tấm đêm Ba Trang[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514446/tong-hop-10-dia-diem-vui-choi-tai-nha-be-nen-ghe-202303030841295618.jpg',
Cơm tấm đêm Ba Trang với những phần cơm tấm hấp dẫn, ngoài sườn bì chả, trứng ra thì còn có những món ăn khác cùng đồ chua đa dạng,
]
Chùa Pháp Bửu[
rating: 4.6,
1 Bùi Công Trừng, Đông Thạnh, Hóc Môn, Thành phố Hồ Chí Minh,
free
24/7
img;'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031143441293.jpg'
]
Khu du lịch Villa H2O[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031144146801.jpg',
rating:3.9,
4C Đ. Đặng Thúc Vịnh, Ấp 3, Hóc Môn, Thành phố Hồ Chí Minh,
 Khoảng 350.000 đ/phòng đến 1.200.000 đ/phòng,
 8h00 - 21h00
]
Khu di tích Ngã Ba Giồng[
rating:4.6,
1 Phan Văn Hớn, Xuân Thới Thượng, Hóc Môn, Thành phố Hồ Chí Minh,
free,
 7h30 - 17h00,
 Khu di tích Ngã Ba Giồng là một địa điểm lý tưởng giúp bạn có thể vừa khám phá vừa có thể học hỏi được những kiến thức lịch sử hữu ích.,
 img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031144401567.jpg'
]
Công Viên Cá Koi RinRin Park[
rating:4.0,
87/8p Xuân Thới Thượng, 6 Ấp Xuân Thới Đông, Xuân Thới Đông 1, Hóc Môn, Thành phố Hồ Chí Minh,
người lớn khoảng 70.000đ/người, trẻ em khoảng 40.000đ/người.,
7h00 - 19h00 ,
RinRin Park là công viên cá coi có quy mô lớn nhất Việt Nam
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031145237388.jpg'
]
Cánh đồng hoa Nhị Bình[
rating:4.2,
Bờ bao sông, Nhị Bình, Hóc Môn, Thành phố Hồ Chí Minh,
100.000đ/người,
 7h30 - 18h30 ,
 img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031145549603.jpg'
]
Di Tích Dinh Quận Hóc Môn (Bảo Tàng Huyện Hóc Môn)[
rating:4.5,
số 1 Lý Nam Đế, Ap Dinh, Tân Xuân, Hóc Môn, Thành phố Hồ Chí Minh,
7h00 - 19h00,
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031146272100.jpg'
]
Chùa Vĩnh Phước[
img:'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031147000714.jpg',
rating:4.4,
28/10A KP.3, Trường Chinh, Tân Thới Nhất, Quận 12, Thành phố Hồ Chí Minh,
free,
4h00 - 14h30
]
Chùa Hoằng Pháp[
rating:4.7,
96 ấp Tân Thới 3, Tân Hiệp, Hóc Môn, Thành phố Hồ Chí Minh
free,
5h00-20h30,
img;'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031147578943.jpg'
Ngôi chùa này là trung tâm văn hóa Phật giáo lớn nhất tại Việt Nam và cũng đang là trung tâm học Phật pháp
]
Khu Vui Chơi Du Lịch Sinh Thái Sunshine Hóc Môn[
img;'https://cdn.tgdd.vn/Files/2023/03/03/1514448/dot-nhap-10-dia-diem-vui-choi-tai-hoc-mon-duoc-yeu-thich-202303031148383600.jpg',
rating:4.5,
Thới Tam Thôn, Hóc Môn, Thành phố Hồ Chí Minh,
Khoảng 200.000đ,
 7h00-21h00,
 tham quan nông trại với đường dù, cầu săn mây, lâu đài, cầu tình yêu, xe lửa, xe tăng, làng u Cơ, cầu khỉ, giếng nước, xay bột, chèo xuồng, lùa vịt, vườn thú, bắt cá, tắm mưa
]
Gà bó xôi 1Ngon: Địa chỉ: 65/6 Nguyễn Thị Huê, ấp Trung Lân, xã Bà Điểm, Huyện Hóc Môn, TPHCM,
Gà hấp hèm 6 Vĩnh: tọa lạc tại 1/132B Ấp Đình, Tân Xuân, Huyện Hóc Môn, TPHCM,
Bún đậu Làng Vòng:[47/5D Nguyễn Hữu Cầu, Trung Mỹ Tây, Hóc Môn, Thành phố Hồ Chí Minh 70000]
Bò kho Mẹ Nấu: tọa lạc tại 56/1 Phan Văn Hớn, Huyện Hóc Môn, TP.HCM




















 */
