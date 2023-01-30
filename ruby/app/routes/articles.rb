# frozen_string_literal: true

require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    articles = @articleCtrl.get_batch

    if articles[:ok]
      { articles: articles[:data] }.to_json
    else
      { msg: 'Could not get articles.' }.to_json
    end
  end

  get('/:id') do
    article = @articleCtrl.get_article(params['id'])

    if article[:ok]
      { article: article[:data] }.to_json
    else
      { msg: article[:msg] }.to_json
    end
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload)

    if summary[:ok]
      { msg: 'Article created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article params['id'], payload

    if summary[:ok]
      { msg: 'Article updated' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:id') do
    summary = @articleCtrl.delete_article params['id']

    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json
    end
  end
end
