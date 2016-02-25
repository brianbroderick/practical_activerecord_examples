class Examples

  # SELECT contents.body
  # FROM "homepages"
  # INNER JOIN "documents"
  #   ON "documents"."id" = "homepages"."document_id"
  # INNER JOIN "contents"
  #   ON "contents"."document_id" = "documents"."id"
  # ORDER BY "homepages"."id" ASC LIMIT 1
  def self.nested_join
    record = Homepage
                .select("contents.body")
                .joins({:document => :contents})
                .first
    Rails.logger.info record.body

    # Returns "This is the homepage."
  end

  # SELECT contents.body, statuses.name as status, document_types.name as type FROM "homepages"
  # INNER JOIN "documents"
  #   ON "documents"."id" = "homepages"."document_id"
  # INNER JOIN "contents"
  #   ON "contents"."document_id" = "documents"."id"
  # INNER JOIN "statuses"
  #   ON "statuses"."id" = "documents"."status_id"
  # INNER JOIN "document_types"
  #   ON "document_types"."id" = "documents"."document_type_id"
  # ORDER BY "homepages"."id" ASC LIMIT 1

  def self.nested_join_with_multiple_children
    record = Homepage
                .select("contents.body, statuses.name as status, document_types.name as type")
                .joins({:document => [:contents, :status, :document_type]})
                .first
    Rails.logger.info "Status: #{record.status}"
    Rails.logger.info "Type:   #{record.type}"
    Rails.logger.info "Body:   #{record.body}"
  end

  # SELECT contents.body, statuses.name as status, document_types.name as type
  # FROM "homepages"
  # INNER JOIN "documents"
  #   ON "documents"."id" = "homepages"."document_id"
  # INNER JOIN "contents"
  #   ON "contents"."document_id" = "documents"."id"
  # INNER JOIN "statuses"
  #   ON "statuses"."id" = "documents"."status_id"
  # INNER JOIN "document_types"
  #   ON "document_types"."id" = "documents"."document_type_id"
  # WHERE "document_types"."name" = 'Page'
  # ORDER BY "homepages"."id" ASC LIMIT 1
  def self.add_some_wheres
    homepage = Homepage
                 .select("contents.body, statuses.name as status, document_types.name as type")
                 .joins({:document => [:contents, :status, :document_type]})
                 .where(document_types: {name: 'Page'})
                 .first
    Rails.logger.info "Status: #{homepage.status}"
    Rails.logger.info "Type:   #{homepage.type}"
    Rails.logger.info "Body:   #{homepage.body}"
  end

  def self.everything_but_the_homepage
    records = Document
                .select("documents.name, contents.body")
                .joins(:contents)
                .joins("LEFT JOIN homepages ON homepages.document_id = documents.id")
                .where("homepages.id IS NULL")

    records.each do |record|
      Rails.logger.info "Name: #{record.name}"
      Rails.logger.info "Body:   #{record.body}"
      Rails.logger.info "########################"
    end
  end

  # SELECT ROUND((up_vote::NUMERIC / (up_vote::NUMERIC + down_vote::NUMERIC)),2)::FLOAT AS approval_rating
  # FROM "documents"
  # INNER JOIN "ratings"
  #   ON "ratings"."document_id" = "documents"."id"
  def self.functions_in_select
    records = Document
                  .select("ROUND((up_vote::NUMERIC / (up_vote::NUMERIC + down_vote::NUMERIC)),2)::FLOAT AS approval_rating")
                  .joins(:ratings)
    records.each do |record|
      Rails.logger.info record.approval_rating
    end

    # Returns [#<Document id: nil>, #<Document id: nil>, #<Document id: nil>]
    # Notice the 'nil' because "id" wasn't selected in the query.
  end

  def self.select_jsonb
    records = Document
                .select("documents.name, details.meta -> 'viewport' as viewport")
                .joins(:detail)

    records.each do |record|
      Rails.logger.info "Name: #{record.name}"
      Rails.logger.info "Viewport: #{record.viewport}"
    end
  end

  def self.where_jsonb
    records = Document
                .select("documents.name, details.meta -> 'viewport' as viewport")
                .joins(:detail)
                .where("details.meta @> '{\"og_site_name\": \"ActiveRecord Examples\"}'")

    records.each do |record|
      Rails.logger.info "Name: #{record.name}"
      Rails.logger.info "Viewport: #{record.viewport}"
    end
  end

  def self.fuzzy_jsonb
    records = Document
                .select("documents.name, details.meta -> 'viewport' as viewport")
                .joins(:detail)
                .where("details.meta->>'og_site_name' ilike '%ActiveRecord%'")

    records.each do |record|
      Rails.logger.info "Name: #{record.name}"
      Rails.logger.info "Viewport: #{record.viewport}"
    end
  end

  def self.jsonb_with_hash_serializer
    records = Detail
                .where("details.meta->>'og_site_name' ilike '%ActiveRecord%'")

    records.each do |record|
      Rails.logger.info "Viewport: #{record.viewport}"
    end
  end



end