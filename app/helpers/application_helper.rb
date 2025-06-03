module ApplicationHelper
    def default_meta_tags
      {
        site: "FTT（Football Training Training）",
        title: "アメフトチーム専用トレーニング管理アプリ",
        reverse: true,
        charset: "utf-8",
        description: "FTTは、アメフトチームのトレーニングを一括管理するサービスです。",
        keywords: "アメフト,トレーニング管理,カレンダー,最大重量,グラフ,チーム管理,フィットネス",
        canonical: request.original_url,
        separator: "|",
        og: {
          site_name: :site,
          title: :title,
          description: :description,
          type: "website",
          url: request.original_url,
          image: image_url("ftttop.jpg"),
          locale: "ja-JP"
        },
        twitter: {
          card: "summary",
          image: image_url("ftttop.jpg")
        }
      }
    end

    def button_class
     "relative h-6 overflow-hidden rounded-md border border-neutral-600 bg-transparent px-6 text-neutral-950 transition-transform duration-150 ease-in-out active:scale-95 active:bg-neutral-100"
    end
end
