import 'package:flutter/material.dart';

const String readyToday =
    'https://images.unsplash.com/photo-1544716278-e513176f20b5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wyMDg4MDd8MHwxfHNlYXJjaHwyNXx8cmVhZGVyfGVufDB8fHx8MTcxNzY4NjI5NXww&ixlib=rb-4.0.3&q=80&w=1080';

const List tags = [
  {"label": "Education", "color": Color(0xFF7871aa)},
  {"label": "Self-development", "color": Color(0xFF7fb069)},
  {"label": "Psychology", "color": Color(0xFFcc7e85)}
];

const List storeTags = [
  {"label": "Education", "color": Color(0xFF7871aa)},
  {"label": "Self-development", "color": Color(0xFF7fb069)},
  {"label": "Psychology", "color": Color(0xFFcc7e85)},
  {"label": "Fantasy", "color": Color(0xFF76818e)},
  {"label": "Adventures", "color": Color(0xFFcf4d6f)},
  {"label": "Science-fiction", "color": Color(0xFFc86fc9)},
  {"label": "Detectives", "color": Color(0xFF8f8073)}
];

const List specialForYouJson = [
  {
    "img": "https://img9.doubanio.com/view/subject/s/public/s34841324.jpg",
    "price": "82.00",
    "title": "法国哲学的历险",
    "sub_title": "自20世纪60年代以来",
    "author_name": "[法] 阿兰·巴迪欧",
    "rate": 7.7,
    "favourite": true,
    "page": "388",
    "buyinfo":
        '[{"book_store": "京东商城", "price": 63.67}, {"book_store": "中国网", "price": 59.00}]',
    "description":
        "本书是法国当代著名哲学家阿兰•巴迪欧的批评文集，汇集了作者对萨特、阿尔都塞、德勒兹、利科、利奥塔、朗西埃等法国当代哲学家的评论文章，这些人中既有他的师长、友人，亦有其“敌手”。在巴迪欧看来，书中谈及的哲学家所各自代表的“奇点”构成了法国当代哲学一个非凡的历险时刻，其规模和创新性足以与希腊古典哲学和德国唯心主义哲学相媲美。这一时刻的法国哲学充分关注主体、现代性、政治和德国哲学遗产等问题，并与文学和精神分析展开竞争，表现出当代哲学家摆脱贤者身份而独树一帜，成为热衷战斗的作家、描绘主体的艺术家和专注创造的爱慕者的热切渴望。作为这一哲学时刻的见证者与在场者，巴迪欧向哲学家同行致以诚挚敬意的同时，也毫不掩饰地表达了质疑与批判。在充满激情与哲思的观点碰撞中，巴迪欧引导我们踏上一条通往未知，也通往真理的哲学历险之路。"
  },
  {
    "img": "https://img3.doubanio.com/view/subject/l/public/s34837793.jpg",
    "price": "65.00",
    "title": "同时代的北方",
    "sub_title": "东北老工业基地的历史经验与当代文化生产研究",
    "author_name": "刘岩",
    "rate": 7.9,
    "favourite": false,
    "page": "304",
    "buyinfo":
        '[{"book_store": "京东商城", "price": 63.67}, {"book_store": "中国网", "price": 59.00}]',
    "description":
        "刘岩教授当代东北文化研究全新力作，戴锦华 汪晖 宋念申——郑重推荐。东北之为“北方”的历史，同时是它成为社会主义中国的工业基地、文化工业基地和另类现代性前沿的历史。本书是文化研究学者刘岩教授的全新论著，以当代文化生产为主要媒介，结合长时段视野，探究“北方”历史经验的同时代性。在这一探究中，东北既是区域辩证的对象，也是尝试以经验克服景观、由记忆解放想象的方法。"
  },
  {
    "img": "https://img3.doubanio.com/view/subject/l/public/s34837902.jpg",
    "price": "118",
    "title": "回音室",
    "sub_title": "1897-1935年跨国的中国画",
    "author_name": "[英] 柯律格",
    "rate": 9.7,
    "favourite": false,
    "page": "514",
    "buyinfo":
        '[{"book_store": "京东商城", "price": 63.67}, {"book_store": "中国网", "price": 59.00}]',
    "description":
        "著名艺术史学者、牛津大学荣休教授柯律格全新中国艺术专著，以考古发掘般的严谨打捞史料中的细节，结合前沿研究方法与成果，呈现艺术史学者多年的思考结晶。跨国界、跨时代、跨语言、跨学科，打破艺术史研究的藩篱，重新认识20世纪初的中国艺术，谢赫在加尔各答，康有为在罗马？摒弃泛泛的传统东西二元论叙事，以全球化的眼光颠覆关于东西方艺术的固有认知。"
  },
  {
    "img": "https://img1.doubanio.com/view/subject/l/public/s34864350.jpg",
    "price": "89.00",
    "title": "瀚海行脚",
    "sub_title": "西域考古60年手记",
    "author_name": "王炳华",
    "rate": 0.0,
    "favourite": true,
    "page": "461",
    "buyinfo":
        '[{"book_store": "京东商城", "price": 63.67}, {"book_store": "中国网", "price": 59.00}]',
    "description":
        "本书收录了西域考古学家王炳华先生在六十载新疆考古与研究中创作的十五篇考古手记，记录和叙述了他从开创伊犁河流域考古开始，到发现孔雀河青铜时代墓葬、主持并参与楼兰、尼雅、克里雅、丹丹乌里克、小河等一系列重大考古发现过程中的所见、所思与所感，也呈现了他一生投身考古事业不断求索的时间脉络。"
  },
  {
    "img": "https://img3.doubanio.com/view/subject/l/public/s34823157.jpg",
    "price": "56.00",
    "title": "食南之徒",
    "sub_title": "小说",
    "author_name": "马伯庸",
    "rate": 8.4,
    "favourite": false,
    "page": "269",
    "buyinfo":
        '[{"book_store": "京东商城", "price": 63.67}, {"book_store": "中国网", "price": 59.00}]',
    "description":
        "ZUI贪吃的大汉使者唐蒙，来到了ZUI会吃的南越之国。这里食材丰富，简直就是饕餮之徒的梦想之地。然而，在美食背后，却涌动着南北对峙、族群隔阂、权位争斗、国策兴废……种种波谲云诡，竟比岭南食材的风味更加复杂。"
  }
];

List reviewsPeople = [
  {
    "img":
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
    "name": "Miranda",
    "rate": 3.0,
    "text": "For once I actually thought Colleen wasn’t going to make me cry."
  },
  {
    "img":
        "https://images.unsplash.com/photo-1523701911984-474f3d34537b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDZ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "name": "Selena",
    "rate": 4.5,
    "text":
        "I wanted to give this book 5 stars but just couldn’t. There are so many f-bombs I almost stopped reading it but I kept at it. Glad I did too. But I will never read it again or listen to it because I don’t need that word in my mind. Why oh why is it so necessary to the story?"
  }
];

const List similarBooksJson = [
  {
    "img": "https://covers.openlibrary.org/b/id/12860069-L.jpg",
    "price": "2.50",
    "title": "I'm Glad My Mom Died",
    "sub_title": "I'm Glad My Mom Died",
    "author_name": "Jennette McCurdy",
    "rate": 4.0,
    "favourite": false,
    "page": "200"
  },
  {
    "img": "https://covers.openlibrary.org/b/id/12842027-L.jpg",
    "price": "5.99",
    "title": "The Love Hypothesis",
    "sub_title": "The Love Hypothesis",
    "author_name": "Ali Hazelwood",
    "rate": 3.5,
    "favourite": false,
    "page": "150"
  },
  {
    "img": "https://covers.openlibrary.org/b/id/402210-L.jpg",
    "price": "2.20",
    "title": "The 48 Laws of Power",
    "sub_title": "The 48 Laws of Power",
    "author_name": "Robert Greene",
    "rate": 4.07,
    "favourite": false,
    "page": "60"
  },
];
