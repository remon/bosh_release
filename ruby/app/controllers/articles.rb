# frozen_string_literal: true

class ArticleController
  def create_article(article)
    article_exists = Article.find_by(title: article['title'])
    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.new(title: article['title'], content: article['content'], created_at: Time.now)
    new_article.save

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)
    article = Article.find_by(id: id)

    return { ok: false, msg: 'Article could not be found' } unless article

    article.update!(title: new_data['title'], content: new_data['content'])

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    res = Article.find_by(id: id)

    if res
      { ok: true, data: res }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(id)
    delete_count = Article.delete(id)

    if delete_count.zero?
      { ok: false }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    articles = Article.all

    if articles.any?
      { ok: true, data: articles }
    else
      { ok: false, msg: 'No articles found' }
    end
  end
end
